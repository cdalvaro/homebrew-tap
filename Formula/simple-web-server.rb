class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://gitlab.com/eidheim/Simple-Web-Server"
  url      "https://gitlab.com/eidheim/Simple-Web-Server/-/archive/v3.1.1/Simple-Web-Server-v3.1.1.tar.gz"
  sha256   "f8f656d941647199e0a2db3cb07788b0e8c30d0f019d28e6ee9281bc48db132d"
  license  "MIT"
  revision 1
  head     "https://gitlab.com/eidheim/Simple-Web-Server.git"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/simple-web-server-3.1.1"
    sha256 cellar: :any_skip_relocation, catalina: "7f5d751fcd82dfa93cdd266a10686592b855bf0ba445ef6c389b0c87b1adbb37"
  end

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
