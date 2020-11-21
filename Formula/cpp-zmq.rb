class CppZmq < Formula
  desc     "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url      "https://github.com/zeromq/cppzmq/archive/v4.7.1.tar.gz"
  sha256   "9853e0437d834cbed5d3c223bf1d755cadee70e7c964c6e42c4c6783dee5d02c"
  license  "MIT"
  head     "https://github.com/zeromq/cppzmq.git"

  livecheck do
    url "https://github.com/zeromq/cppzmq/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
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
