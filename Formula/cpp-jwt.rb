class CppJwt < Formula
  desc     "JSON Web Token library for C++"
  homepage "https://github.com/arun11299/cpp-jwt"
  url      "https://github.com/arun11299/cpp-jwt/archive/refs/tags/v1.4.tar.gz"
  sha256   "1cb8039ee15bf9bf735c26082d7ff50c23d2886d65015dd6b0668c65e17dd20f"
  license  "MIT"
  revision 2
  head     "https://github.com/arun11299/cpp-jwt.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "199ba0297d4a3397b049a6a6ab664af375c7b7f27e90a31d8df70cc9e055ddff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0383f4f7704545f2bb6e3b28b9177f24f51a996264dd05443427d2015247ca"
    sha256 cellar: :any_skip_relocation, ventura:       "ccb56ccf2a9714cfbb69aadd7ccd8e8613d5134a3d64cd001c6e75190312e7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0852bf697c30132204f56abcb15320acef08d96fd0c59e145b977f4a85b96012"
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

    system "cmake", ".", *std_cmake_args, *custom_args
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

    system ENV.cxx, "-I#{include}", "-std=c++14",
           "-I#{Formula["openssl"].include}",
           *custom_args,
           "test.cpp", "-o", "test"
    system "./test"
  end
end
