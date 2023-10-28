class CppZmq < Formula
  desc     "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url      "https://github.com/zeromq/cppzmq/archive/refs/tags/v4.10.0.tar.gz"
  sha256   "c81c81bba8a7644c84932225f018b5088743a22999c6d82a2b5f5cd1e6942b74"
  license  "MIT"
  head     "https://github.com/zeromq/cppzmq.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-zmq-4.9.0"
    sha256 cellar: :any_skip_relocation, monterey: "135ba553cac661ac9a608e96880307852719b21e6996d7796e428dbd396f3515"
    sha256 cellar: :any_skip_relocation, big_sur:  "76849717683fae74b865e69cbcf31e508cd91c571174d9fc0b9231290dc19fb3"
    sha256 cellar: :any_skip_relocation, catalina: "1706b12442298413e6b1a530f782463c4a5f3f5d80daa9800b7ee0d98390a218"
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
