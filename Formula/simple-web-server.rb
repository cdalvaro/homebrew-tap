class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://github.com/cdalvaro/Simple-Web-Server"
  url      "https://github.com/cdalvaro/Simple-Web-Server/archive/refs/tags/v3.2.0.tar.gz"
  sha256   "30717b71c7c10ce894cfe47e1490eaf14652d750d381fdc7ebba53682af03335"
  license  "MIT"
  revision 1
  head     "https://github.com/cdalvaro/Simple-Web-Server.git", branch: "master"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/simple-web-server-3.2.0_1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf1017fab31d4e5e592b029c64ce4fbc2313eec3d8151a4037990bf996948bb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "156387fc77d469219f6ed44ee57ed5b6b6492e4196c2faf34460eb04ee2ae4f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76a3360f9339abedafd655cf1933624980e18a8be270e69483735434e4d3ac34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9a323c39ee501d66c3cddf7cd02b02f6d9f366dc1f6f06fd6a599dfe2a9cbd77"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    port = free_port
    (testpath/"test.cpp").write <<~CPP
      #include <simple-web-server/server_http.hpp>

      int main() {
        using HttpServer = SimpleWeb::Server<SimpleWeb::HTTP>;
        HttpServer server;
        server.config.address = "127.0.0.1";
        server.config.port = #{port};
        server.resource["^/$"]["GET"] = [](std::shared_ptr<HttpServer::Response> response,
                                          std::shared_ptr<HttpServer::Request>) {
          response->write("Hello, Homebrew!");
        };
        server.start();
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-pthread", "-I#{include}",
                    "-I#{formula_opt_include("boost")}", "-o", "test"

    pid = fork { exec "#{testpath}/test" }
    begin
      output = shell_output("curl --silent --show-error --fail --include --retry 5 --retry-connrefused " \
                            "--retry-delay 1 --max-time 5 http://127.0.0.1:#{port}/")
      assert_match "HTTP/1.1 200 OK\r\n", output
      assert_equal "Hello, Homebrew!", output.split("\r\n\r\n", 2).last
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
