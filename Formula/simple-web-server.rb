class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://github.com/cdalvaro/Simple-Web-Server"
  url      "https://github.com/cdalvaro/Simple-Web-Server/archive/refs/tags/v3.2.0.tar.gz"
  sha256   "30717b71c7c10ce894cfe47e1490eaf14652d750d381fdc7ebba53682af03335"
  license  "MIT"
  head     "https://github.com/cdalvaro/Simple-Web-Server.git", branch: "master"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/simple-web-server-3.1.1_4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea8b607e1c7118cf371f82acc457eb67d3592593eb9014971139de4bdf3d9d9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93aedd63abcc2990f13b1b22e5f83573380246c8939fac8ed1dfc0c16934dc3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca283ee5b9c9a1e4ea2e5c19a8afeb683eb1d370eaf9797aed7a2e75cc0993a9"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "make", "install"
  end
end
