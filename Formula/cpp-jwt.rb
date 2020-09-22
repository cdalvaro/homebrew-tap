class CppJwt < Formula
  desc     'JSON Web Token library for C++'
  homepage 'https://github.com/arun11299/cpp-jwt'
  url      'https://github.com/arun11299/cpp-jwt/archive/v1.3.tar.gz'
  sha256   '792889f08dd1acbc14129d11e013f9ef46e663c545ea366dd922402d8becbe05'
  head     'https://github.com/arun11299/cpp-jwt.git'
  bottle   :unneeded

  option 'with-nlohmann-json', "Use nlohmann-json library instead of the vendored one"

  depends_on 'cmake' => :build
  depends_on 'nlohmann-json' => :optional
  depends_on 'openssl@1.1'

  def install
    custom_args = [
      "-DCPP_JWT_BUILD_EXAMPLES=OFF",
      "-DCPP_JWT_BUILD_TESTS=OFF",
    ]

    if build.with? "nlohmann-json"
      custom_args << "-DCPP_JWT_USE_VENDORED_NLOHMANN_JSON=OFF"
    else
      custom_args << "-DCPP_JWT_USE_VENDORED_NLOHMANN_JSON=ON"
    end

    system "cmake", ".", *std_cmake_args, *custom_args
    system "make", "install"
  end

  test do
    (testpath / 'test.cpp').write <<~EOS
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
    if !build.with? "nlohmann-json"
      custom_args << "-DCPP_JWT_USE_VENDORED_NLOHMANN_JSON"
    end

    system ENV.cxx, "-I#{include}", '-std=c++14',
           "-I#{Formula['openssl@1.1'].include}",
           *custom_args,
           'test.cpp', '-o', 'test'
    system './test'
  end
end
