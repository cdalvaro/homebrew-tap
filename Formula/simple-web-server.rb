class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://gitlab.com/eidheim/Simple-Web-Server"
  url      "https://gitlab.com/eidheim/Simple-Web-Server/-/archive/v3.1.1/Simple-Web-Server-v3.1.1.tar.gz"
  sha256   "f8f656d941647199e0a2db3cb07788b0e8c30d0f019d28e6ee9281bc48db132d"
  license  "MIT"
  revision 4
  head     "https://gitlab.com/eidheim/Simple-Web-Server.git", branch: "master"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/simple-web-server-3.1.1_4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea8b607e1c7118cf371f82acc457eb67d3592593eb9014971139de4bdf3d9d9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93aedd63abcc2990f13b1b22e5f83573380246c8939fac8ed1dfc0c16934dc3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca283ee5b9c9a1e4ea2e5c19a8afeb683eb1d370eaf9797aed7a2e75cc0993a9"
  end

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "openssl"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args, "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "make", "install"
  end
end
