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
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.2.1"
    sha256 cellar: :any_skip_relocation, ventura:  "a4cf3e5ab99a1c1114cf6554b7638a28162354229285b74f17a9be24e530a68a"
    sha256 cellar: :any_skip_relocation, monterey: "6ffd1ab8d45bc705c10d48aeede0866930038266bdfcac8898922d8be6dac49e"
    sha256 cellar: :any_skip_relocation, big_sur:  "04a96972baa17547c78ccc1271be48a58d0fee0635a71268e0c03ef2d98d23bf"
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
