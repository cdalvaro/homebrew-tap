class CppJwt < Formula
  desc     "JSON Web Token library for C++"
  homepage "https://github.com/arun11299/cpp-jwt"
  url      "https://github.com/arun11299/cpp-jwt/archive/refs/tags/v1.4.tar.gz"
  sha256   "1cb8039ee15bf9bf735c26082d7ff50c23d2886d65015dd6b0668c65e17dd20f"
  license  "MIT"
  revision 1
  head     "https://github.com/arun11299/cpp-jwt.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-jwt-1.4_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "53c873902fd5e91c4a78fff61b329de72d8f97e1d4334e07a266ec3d101de421"
    sha256 cellar: :any_skip_relocation, ventura:      "a0f64f16d5543ae43b239f173339f1342be4a09812ceeac87a542cd95ce14ce1"
    sha256 cellar: :any_skip_relocation, monterey:     "282fbd87497e0da2bb36ac9b47d4efcfebe8293c7fe571f162fa0d89e451d8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a01009d1d710c3a31789859cdce3788d2ab9228d67379634be6efd6a76cfdd4c"
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
