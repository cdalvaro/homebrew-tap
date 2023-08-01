class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/refs/tags/v1.2.tar.gz"
  sha256 "59aa2c1690fff4ac38696f850a951484c844f0f40a0d0ab3a5b5dc588b09ee9b"
  license "Apache-2.0"
  head "https://github.com/catboost/catboost.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.1.1"
    sha256 cellar: :any_skip_relocation, monterey: "cc422b1970e5d7960671d45af0a62e65fa51a70ce806380f08ff0766adfcce08"
    sha256 cellar: :any_skip_relocation, big_sur:  "ed2e7af7d3624205e73254bc44240ea5aadaddb02bf5f5596a7bd7b9fc2a61bc"
    sha256 cellar: :any_skip_relocation, catalina: "037772205515d1636d42a8137e5961b6d1fa8e67f539919aaadf5804a1dab788"
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
