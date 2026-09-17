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
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-jwt@1.4-1.4_2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1b9f31744659aa4b48d748e53411776ff6202755dbe66da8d8b62ff39a66527"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "345b119d097ece3b73bd0f58d64cc6957a73ee047083971c2ee1acecee1de6e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b24f6540a4979ecb946680b2680e1bfe6e242e704263c4940be92c55957fbd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ed872cdf26163cb1a5facaf66c5e8711ecb5e27284b371e2cc333618013d5e22"
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
