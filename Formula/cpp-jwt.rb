class CppJwt < Formula
  desc     "JSON Web Token library for C++"
  homepage "https://github.com/arun11299/cpp-jwt"
  url      "https://github.com/arun11299/cpp-jwt/archive/refs/tags/v1.5.1.tar.gz"
  sha256   "7e5ec6891254c8f00128952ed6b9a73d827539136c3b804563521a0042abe72c"
  license  "MIT"
  revision 1
  head     "https://github.com/arun11299/cpp-jwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-jwt-1.5.1_1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3fb3c624fa7b80bddcef3aaae0f8b8204ceed43a2dfee903c0c1cdee48119e1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e4db7c3f5e63c9f7346a19789604bf4f7bb493656f333ef9fd558d6e857c56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9992b2bbced146281cef6d01e3f40e3b27d5271d72a840d3570c4291e7f9668f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dacb4229df73c3c7b07689c80d153b39d0e1d89c04264165c697771f6fed75a0"
  end

  option "with-nlohmann-json", "Use nlohmann-json library instead of the vendored one"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "nlohmann-json" => :optional

  def install
    custom_args = [
      "-DCPP_JWT_BUILD_EXAMPLES=OFF",
      "-DCPP_JWT_BUILD_TESTS=OFF",
    ]

    use_vendored_nlohmann = build.with?("nlohmann-json") ? "OFF" : "ON"
    custom_args << "-DCPP_JWT_USE_VENDORED_NLOHMANN_JSON=#{use_vendored_nlohmann}"

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args, *custom_args
    system "make", "install"
  end

  test do
    (testpath / "test.cpp").write <<~EOS
      #include <iostream>
      #include <map>
      #include <chrono>
      #include <jwt/jwt.hpp>
      int main(void) {
        using namespace jwt::params;
        jwt::jwt_object obj{algorithm("HS256"), secret("secret")};
        obj.add_claim("iss", "arun.muralidharan")
           .add_claim("sub", "admin")
           .add_claim("id", "a-b-c-d-e-f-1-2-3")
           .add_claim("iat", 1513862371)
           .add_claim("exp", std::chrono::system_clock::now());
        assert(obj.has_claim(jwt::registered_claims::expiration));
        obj.remove_claim("exp");
        assert(!obj.has_claim(jwt::registered_claims::expiration));
        obj.remove_claim(jwt::registered_claims::subject);
        assert(!obj.has_claim("sub"));
        return EXIT_SUCCESS;
      }
    EOS

    custom_args = []
    custom_args << "-DCPP_JWT_USE_VENDORED_NLOHMANN_JSON" if build.without? "nlohmann-json"

    system ENV.cxx, "test.cpp",
           "-I#{include}", "-std=c++14",
           "-I#{Formula["openssl"].include}",
           "-L#{Formula["openssl"].lib}",
           "-lssl", "-lcrypto",
           *custom_args,
           "-o", "test"
    system "./test"
  end
end
