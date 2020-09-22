class JwtCpp < Formula
  desc     "A header only library for creating and validating json web tokens in C++"
  homepage "https://github.com/Thalhammer/jwt-cpp"
  url      "https://github.com/Thalhammer/jwt-cpp/archive/v0.4.0.tar.gz"
  sha256   "f0dcc7b0e8bef8f9c3f434e7121f9941145042c9fe3055a5bdd709085a4f2be4"
  head     "https://github.com/Thalhammer/jwt-cpp.git"
  bottle   :unneeded

  option "with-external-picojson", "Use find_package() to locate the picojson header"
  option "without-jwt-cpp-picojson", "Do not provide the picojson template specialiaze"
  option "without-jwt-cpp-base64", "Do not include the base64 implementation from this library"

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    custom_args = [
      "-DBUILD_TESTS=OFF",
      "-DBUILD_EXAMPLES=OFF",
      "-DCOVERAGE=OFF",
    ]

    if build.with? "external-picojson"
      custom_args << "-DEXTERNAL_PICOJSON=ON"
    else
      custom_args << "-DEXTERNAL_PICOJSON=OFF"
    end

    if build.with? "jwt-cpp-picojson"
      custom_args << "-DDISABLE_JWT_CPP_PICOJSON=OFF"
    else
      custom_args << "-DDISABLE_JWT_CPP_PICOJSON=ON"
    end

    if build.with? "jwt-cpp-base64"
      custom_args << "-DDISABLE_JWT_CPP_BASE64=OFF"
    else
      custom_args << "-DDISABLE_JWT_CPP_BASE64=ON"
    end

    system "cmake", ".", *std_cmake_args, *custom_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <jwt-cpp/jwt.h>
      int main(void) {
        std::string token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXUyJ9.eyJpc3MiOiJhdXRoMCJ9.AbIJTDMFc7yUa5MhvcP03nJPyCPzZtQcGEp-zWfOkEE";
	      auto decoded = jwt::decode(token);
	      assert(decoded.has_algorithm());
        assert(decoded.has_type());
        assert(!decoded.has_content_type());
        assert(!decoded.has_key_id());
        assert(decoded.has_issuer());
        assert(!decoded.has_subject());
        assert(!decoded.has_audience());
        assert(!decoded.has_expires_at());
        assert(!decoded.has_not_before());
        assert(!decoded.has_issued_at());
        assert(!decoded.has_id());
        assert("HS256" == std::string(decoded.get_algorithm()));
        assert("JWS" == std::string(decoded.get_type()));
        assert("auth0" == std::string(decoded.get_issuer()));
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-std=c++14",
           "-L#{Formula["jwt-cpp"].opt_lib}",
           "-L#{Formula["openssl@1.1"].opt_lib}",
           "-I#{Formula["openssl@1.1"].include}",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
