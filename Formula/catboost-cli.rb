class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "38470f24efd1bc6d0791d1acc686dc0617af9dab04f7b2065e747f560a9c3952"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.0.0"
    sha256 cellar: :any_skip_relocation, big_sur:  "a0ca475212ed7e176f59e78739c958da7f4a4b9816b311baa06b47856845e084"
    sha256 cellar: :any_skip_relocation, catalina: "c1cc80e00d43ef5168216e95c219be130812ee1b05d3e5d29631a64ba26801c5"
  end

  def install
    cd "#{buildpath}/catboost/app" do
      ENV["YA_CACHE_DIR"] = "./.ya"
      system "../../ya", "make", "-r", "-o", "#{buildpath}/brew-build"
      bin.install "#{buildpath}/brew-build/catboost/app/catboost"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/catboost --version")
  end
end
