class CppJwtAT14 < Formula
  desc     "JSON Web Token library for C++"
  homepage "https://github.com/arun11299/cpp-jwt"
  url      "https://github.com/arun11299/cpp-jwt/archive/refs/tags/v1.4.tar.gz"
  sha256   "1cb8039ee15bf9bf735c26082d7ff50c23d2886d65015dd6b0668c65e17dd20f"
  license  "MIT"
  head "https://github.com/arun11299/cpp-jwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "356f162e9997e113f9ccad89c2961ddba4fab3d47df00a1a4e563ea2f3914457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a0ae2f43f0d4dfcda438409b7cf10c1837da66576fbde7c4ae23300cbac8aa7"
    sha256 cellar: :any_skip_relocation, ventura:       "8b61a4104a27468653cd993ea2abb593035526b4486253832f0a46fe1ce0222e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a6d123f12e274a83fbf464c1cd0d78f5989b4d00fddd74b776b5a638507781"
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
