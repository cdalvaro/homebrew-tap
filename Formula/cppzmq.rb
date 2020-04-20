class Cppzmq < Formula
  desc     "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url      "https://github.com/zeromq/cppzmq/archive/v4.6.0.tar.gz"
  sha256   "e9203391a0b913576153a2ad22a2dc1479b1ec325beb6c46a3237c669aef5a52"
  head     "https://github.com/zeromq/cppzmq.git"
  bottle   :unneeded

  depends_on "cmake" => :build
  depends_on "zmq"

  def install
    system "cmake", ".", *std_cmake_args
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
