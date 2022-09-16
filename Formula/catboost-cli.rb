class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "867c0beb9944a382a5680342c77e7718d0b43d862d9f4fd58b18a2a76f2af92c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.0.3"
    sha256 cellar: :any_skip_relocation, big_sur:  "3f0e8ec63373dfac4a913960a3f58db22a1ffc80ddeca4553bcb4e1b8184b9fe"
    sha256 cellar: :any_skip_relocation, catalina: "3d440f29429c5a87601af0865352bc0e08fcd50cef2c72d123d162b31e5aa279"
  end

  def install
    inreplace buildpath/"ya", "#!/usr/bin/env python", "#!/usr/bin/env python3"
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
