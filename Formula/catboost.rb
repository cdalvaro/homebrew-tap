class Catboost < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/v0.26.1.tar.gz"
  sha256 "a82971e13facc8421c14755bfc489be9a3d21f81ec529044db90a9b53cc32b01"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-0.25.1"
    sha256 cellar: :any_skip_relocation, big_sur:  "faeddb0922d27bd63eecf3db006f967d88209dfe04a6a586b8a38da3b36c73f8"
    sha256 cellar: :any_skip_relocation, catalina: "2c1c3fd57e8fd9d53aca9e19c08a6192c52f51386c7da2e4920980ac3041bd55"
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
