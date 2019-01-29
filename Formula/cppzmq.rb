class Cppzmq < Formula
  desc     "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url      "https://github.com/zeromq/cppzmq/archive/v4.3.0.tar.gz"
  sha256   "27d1f56406ba94ee779e639203218820975cf68174f92fbeae0f645df0fcada4"
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
