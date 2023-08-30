class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "b1cf4458415a639f26e953bc4e2877d68d2a711f457a725ef93cbe24363725f0"
  license "Apache-2.0"
  head "https://github.com/catboost/catboost.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.2"
    sha256 cellar: :any_skip_relocation, ventura:  "e73871bdf5c2f259ecbcbbe9d76d84d1ceecca13c0521d0a3c1c588848ed77d4"
    sha256 cellar: :any_skip_relocation, monterey: "92e55a9d8533e5a356673ec6164591ce47fc6f2318a50b92ee7703b964c1b271"
    sha256 cellar: :any_skip_relocation, big_sur:  "8ae74347606851d717260ca1440b181989415a4e2546e4008a6b09fe4b51dcba"
  end

  depends_on "cmake" => :build
  depends_on "conan@1" => :build
  depends_on "ninja" => :build

  def install
    extra_cmake_args = [
      "-S",
      buildpath.to_s,
      "-B",
      "#{buildpath}/brew-build",
      "-G",
      "Ninja",
      "-DCATBOOST_COMPONENTS=app",
      "-DHAVE_CUDA=NO",
      "-DCMAKE_TOOLCHAIN_FILE=#{buildpath}/build/toolchains/clang.toolchain",
    ]
    system "cmake", *extra_cmake_args, *std_cmake_args
    system "ninja", "-C", "#{buildpath}/brew-build", "catboost"

    bin.install "#{buildpath}/brew-build/catboost/app/catboost" => "catboost-#{version}"
    bin.install_symlink "catboost-#{version}" => "catboost"
  end

  test do
    assert_predicate bin/"catboost", :exist?
  end
end
