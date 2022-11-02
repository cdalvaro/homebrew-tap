class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9ae3e79d1425c599bcfe2061712a601385cbf461ee9f0a75b0e54b19e83fdc93"
  license "Apache-2.0"
  revision 1

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

  def install
    build_args = [
      "--target-platform",
      "DEFAULT-DARWIN-#{Hardware::CPU.arm? ? "ARM64" : "X86_64"}",
      "--build",
      "release",
      "-o",
      "#{buildpath}/brew-build",
    ]

    cd "#{buildpath}/catboost/app" do
      ENV["YA_CACHE_DIR"] = "./.ya"
      system "../../ya", "make", *build_args
      bin.install "#{buildpath}/brew-build/catboost/app/catboost"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/catboost --version")
  end
end
