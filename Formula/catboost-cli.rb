class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9ae3e79d1425c599bcfe2061712a601385cbf461ee9f0a75b0e54b19e83fdc93"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.1"
    sha256 cellar: :any_skip_relocation, monterey: "d16001657cb83f7efa3eb902cdba24aee8acb6755c2797c3bd050d43afc8de88"
    sha256 cellar: :any_skip_relocation, big_sur:  "2253bfdb3d5d622aed9bdadf7aff1181a18145605182c313b6837c518e47abd8"
    sha256 cellar: :any_skip_relocation, catalina: "e6987981373351d6c378c47dd08988c5bb268a6ec46a8e1f958f708d8d9cdb81"
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
