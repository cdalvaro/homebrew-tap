class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/refs/tags/v1.1.tar.gz"
  sha256 "baed3f28edd0d3accaed375a9ae0feb7ec7f27592e63c7920338f29c8c0395b4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.0.6_1"
    sha256 cellar: :any_skip_relocation, monterey: "a6feed4f19da69a1028a7658d86dde6724a963d0f72084b97af3a626e74c884a"
    sha256 cellar: :any_skip_relocation, big_sur:  "0fac73522b1fdab12f58a7a7b779d7ac0989d82e1e3034cc3764a3da3b3dc696"
    sha256 cellar: :any_skip_relocation, catalina: "30fa2a4ef3ca6ebdc8bfd86ef237291c59b4b68a6ad0fc61c7f12e43dae74a6a"
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
