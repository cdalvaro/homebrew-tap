class SimpleWebServer < Formula
  desc     "A very simple, fast, multithreaded, platform independent HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://gitlab.com/eidheim/Simple-Web-Server"
  url      "https://gitlab.com/eidheim/Simple-Web-Server/-/archive/v3.0.2/Simple-Web-Server-v3.0.2.tar.gz"
  sha256   "9997079979c542e49809c4ce20942f2eed60b34505b9e757d08966488d18d319"
  head     "https://gitlab.com/eidheim/Simple-Web-Server.git"
  bottle   :unneeded

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "boost"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
