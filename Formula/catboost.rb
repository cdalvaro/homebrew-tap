class Catboost < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/v0.25.tar.gz"
  sha256 "26c06716e7e235e5e837123be0251bacd23595b188d68194d88263e6ae56bf8f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-0.25"
    sha256 cellar: :any_skip_relocation, big_sur:  "9547b0268a82eb10d7d37c08550e85d9669821fb30b582d32309364154ec1ea3"
    sha256 cellar: :any_skip_relocation, catalina: "87d5022f436425f3b72c9a2f025ab40e12e5827d25c3ca088ce1a69d9cce3b42"
  end

  resource "yandex-resources" do
    url "https://storage.mds.yandex.net/get-devtools-opensource/233854/76eebdce3caf642db6f4ff3bbc441b41"
    sha256 "add0f1c82e8c367c286486921a9e2a9378d241a2c6d9832cdcab678f009b6b07"
  end

  resource "yandex" do
    url "https://storage.mds.yandex.net/get-devtools-opensource/373962/2057406071"
    sha256 "4dc49947ec9085228a804c73dbb0746fc9a035e59e4b45a74095a5474f34fde7"
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
