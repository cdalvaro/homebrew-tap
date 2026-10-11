class SimpleWebServer < Formula
  desc     "HTTP and HTTPS server and client library implemented using C++11 and Boost.Asio"
  homepage "https://github.com/cdalvaro/Simple-Web-Server"
  url      "https://github.com/cdalvaro/Simple-Web-Server/archive/refs/tags/v3.2.0.tar.gz"
  sha256   "30717b71c7c10ce894cfe47e1490eaf14652d750d381fdc7ebba53682af03335"
  license  "MIT"
  head     "https://github.com/cdalvaro/Simple-Web-Server.git", branch: "master"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/simple-web-server-3.2.0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9169a1f295640d0685373d66f95f730806787fccdb4bcd024358a01fea2ebae0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68ee4dccfb19219ad482355246b155a7f9a1504c8cb982ddfc55fde20cf787b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcc3e57f7555a51ad3091f1f163105361de2166ca58f16bd238a793a79847854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f86ab0b61c92d36deba6a27555cf64b790936da218504a3dc9b0525dbdc6073a"
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
