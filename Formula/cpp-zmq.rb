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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f177a06b2d9f1541a424d9482418491649cdc7922a3c5b3c3d275f37236f834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a7f74fc1708266db690c49eda545dbccba4ef534e3ba53a8f7dc22c85449c4"
    sha256 cellar: :any_skip_relocation, ventura:       "6b220545eadfdb0273be30b0f9f6f189565513f588288f0d2730a6aa70fa8423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b62aa613b53b1212b7c2dc8d7114e42cc9391ffba30090787a6d8beb19d1147"
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
