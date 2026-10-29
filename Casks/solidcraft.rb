cask "solidcraft" do
  version "0.26.0"
  sha256 "2a62e0c7e9dce45cb6ee6fa1ebe322110a0d234da1b820f31bf920e2512e8b24"

  url "https://github.com/tangency-labs/solidcraft/releases/download/v#{version}/solidcraft-#{version}-macos-universal.dmg"
  name "SolidCraft"
  desc "Open-source parametric 3D CAD"
  homepage "https://solidcraft.io/"

  depends_on :macos

  app "SolidCraft.app"
  binary "#{appdir}/SolidCraft.app/Contents/MacOS/solidcraft-cli"

  zap trash: [
    "~/Library/Application Support/SolidCraft/app.ron",
    "~/Library/Application Support/SolidCraft/graphics.json",
  ]
end
