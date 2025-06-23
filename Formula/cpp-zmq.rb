class CppZmq < Formula
  desc     "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url      "https://github.com/zeromq/cppzmq/archive/refs/tags/v4.11.0.tar.gz"
  sha256   "0fff4ff311a7c88fdb76fceefba0e180232d56984f577db371d505e4d4c91afd"
  license  "MIT"
  head     "https://github.com/zeromq/cppzmq.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de00d05a7ca1fc6c3aacd2a9f7694b601e85d6ecaf895bdcd43cef98604eed5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b0325d177384623d493fdd84753cc8035bf7eeec736c6416700139e3935c60b"
    sha256 cellar: :any_skip_relocation, ventura:       "e720cbba10f7793abd1a4b9f5cac81e2d71c8a67c7f049fcad0fec0530f545cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f4d8b2ecfb56727d7ac0253cfb5ba4d4438fa64c479643945ef53610c6bfcb"
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
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{include}", "-L#{HOMEBREW_PREFIX}/lib",
                    "-lzmq", "-o", "test"
    system "./test"
  end
end
