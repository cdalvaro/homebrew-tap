class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://gitlab.com/eidheim/Simple-Web-Server"
  url      "https://gitlab.com/eidheim/Simple-Web-Server/-/archive/v3.1.1/Simple-Web-Server-v3.1.1.tar.gz"
  sha256   "f8f656d941647199e0a2db3cb07788b0e8c30d0f019d28e6ee9281bc48db132d"
  license  "MIT"
  revision 4
  head     "https://gitlab.com/eidheim/Simple-Web-Server.git", branch: "master"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/simple-web-server-3.1.1_3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0d25af5eab1f346f8271842b67d8d7ed636471327920601aa4bcc0a308096f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ccd0ef021fff224704b3c85f5dc75a985fbae257fb3afaba8300bfb04dda909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d53a4dd8c8968c7abb1e63f2c3db7100aeac3c7f6225497a19ecec4b1e5203"
  end

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "openssl"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args, "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "make", "install"
  end
end
