class CppJwtAT14 < Formula
  desc     "JSON Web Token library for C++"
  homepage "https://github.com/arun11299/cpp-jwt"
  url      "https://github.com/arun11299/cpp-jwt/archive/refs/tags/v1.4.tar.gz"
  sha256   "1cb8039ee15bf9bf735c26082d7ff50c23d2886d65015dd6b0668c65e17dd20f"
  license  "MIT"
  revision 2
  head "https://github.com/arun11299/cpp-jwt.git", branch: "master"

  livecheck do
    skip "Pinned to a specific, unmaintained series"
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-jwt@1.4-1.4_1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "153798ba07b35e847ae99324159acdd2bc28edb677671b53b6bff2040b0286e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3529dca9b925b738110af61a091c02b8ed92031aea33db8783fed48ed910dcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9a8a10615c9bcefad6af7abd1047f0da0518eb33c901e32dec09002c2c6effa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "91fb8d8a03c0684c5e91fdfb7bd910ff494884c6595fb79591de3a940881b9e4"
  end

  keg_only :versioned_formula

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
