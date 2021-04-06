class Catboost < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/v0.25.1.tar.gz"
  sha256 "cfc5941dfe1b0bc827aa401702e61c2aa302613e7f68d42fee83e212712278da"
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

  resource "yandex-resources" do
    url "https://storage.mds.yandex.net/get-devtools-opensource/250854/e0789c39918157ef0786904445f7c9af"
    sha256 "4a4e57756164e62d7032a2b2cddcc9e12cf04296ac358b32bcbc74a613da11f3"
  end

  resource "yandex" do
    url "https://storage.mds.yandex.net/get-devtools-opensource/373962/2086184410"
    sha256 "2ca02a08ca0b0714428b8b38960933070786d7bbe35ddcc5cfc7672d44176f8d"
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
