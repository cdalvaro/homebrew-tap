class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://gitlab.com/eidheim/Simple-Web-Server"
  url      "https://gitlab.com/eidheim/Simple-Web-Server/-/archive/v3.1.1/Simple-Web-Server-v3.1.1.tar.gz"
  sha256   "f8f656d941647199e0a2db3cb07788b0e8c30d0f019d28e6ee9281bc48db132d"
  license  "MIT"
  revision 1
  head     "https://gitlab.com/eidheim/Simple-Web-Server.git"

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74e8cdc04779612c8a2cf12c4fcc5996feb2706438a2397aaed8fe16f3777107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0cb4fd948065163412e1edfaaf573f1d88fd5c17dd9a93fc3f077fb390aac21"
    sha256 cellar: :any_skip_relocation, ventura:       "188770270aaec21f026833ee532d1bb4d32bd4f8b40181d9192922887d9869e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e99f78eee08cec869e258a20fa032e1662a691e2a38bc6ecfae380c9f8a7fd9"
  end

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
