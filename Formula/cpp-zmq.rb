class CppZmq < Formula
  desc     "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url      "https://github.com/zeromq/cppzmq/archive/v4.9.0.tar.gz"
  sha256   "3fdf5b100206953f674c94d40599bdb3ea255244dcc42fab0d75855ee3645581"
  license  "MIT"
  head     "https://github.com/zeromq/cppzmq.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-zmq-4.8.1"
    sha256 cellar: :any_skip_relocation, big_sur:  "d10f518e98d3edd8734d9b41151de22e580b3239afff7eb8e59e5875d2ae0011"
    sha256 cellar: :any_skip_relocation, catalina: "d39e23d23e1f255733ce7eb0e1cd5ca5b1bb3d6ded09446f3c334cbac6326814"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq"

  def install
    custom_args = [
      "-DCPPZMQ_BUILD_TESTS=OFF",
    ]

    system "cmake", ".", *std_cmake_args, *custom_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <zmq.hpp>
      int main()
      {
        zmq::context_t context;
        zmq::socket_t socket(context, ZMQ_ROUTER);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{HOMEBREW_PREFIX}/lib",
                    "-lzmq", "-o", "test"
    system "./test"
  end
end
