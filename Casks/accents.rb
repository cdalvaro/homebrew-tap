cask "accents" do
  version "3.0,4"
  sha256 :no_check

  url "https://tars.mahdi.jp/apps/accents.zip"
  name "Accents"
  desc "Unlock additional system accent colors"
  homepage "https://mahdi.jp/apps/accents"

  livecheck do
    url :url
    strategy :extract_plist
  end

  depends_on :macos

  app "Accents.app"
end
