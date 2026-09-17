class CppZmq < Formula
  desc     "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url      "https://github.com/zeromq/cppzmq/archive/refs/tags/v4.11.0.tar.gz"
  sha256   "0fff4ff311a7c88fdb76fceefba0e180232d56984f577db371d505e4d4c91afd"
  license  "MIT"
  revision 1
  head     "https://github.com/zeromq/cppzmq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-zmq-4.11.0_1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74c775db5a8a7f409bc7c55883b47d783bbe11b02dc076cc2ab26d8a5d6fe700"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e09d582c353cdc6c22aa2d26eb9a65c1d2497a5b6dae2bf89bb88597c45baa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6427ea64016210f149ceef7d09535bf6ed93198228a15ecb5e8b022c9cef3958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "70c5733896b4d5d570e6a6228906594b282d25b5f88d5d796d2b14a90145cabe"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq"

  def install
    custom_args = [
      "-DCPPZMQ_BUILD_TESTS=OFF",
    ]

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args, *custom_args
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
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{include}", "-L#{HOMEBREW_PREFIX}/lib",
                    "-lzmq", "-o", "test"
    system "./test"
  end
end
