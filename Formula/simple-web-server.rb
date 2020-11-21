class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://gitlab.com/eidheim/Simple-Web-Server"
  url      "https://gitlab.com/eidheim/Simple-Web-Server/-/archive/v3.1.1/Simple-Web-Server-v3.1.1.tar.gz"
  sha256   "f8f656d941647199e0a2db3cb07788b0e8c30d0f019d28e6ee9281bc48db132d"
  license  "MIT"
  head     "https://gitlab.com/eidheim/Simple-Web-Server.git"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
