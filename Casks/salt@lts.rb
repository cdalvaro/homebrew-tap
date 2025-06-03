cask "salt@lts" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.11"

  on_macos do
    sha256 arm:   "bf2a8b24624511a03983c9fa84a0f8d6295b61c651969fbf791402d3ff6dd4cc",
           intel: "9d9546439695aa2f1090d63816484ea1bc811ddc7048a2ce692cff8cf26cbad0"
  end

  on_linux do
    sha256 :no_check
  end

  url "https://packages.broadcom.com/artifactory/saltproject-generic/macos/#{version}/salt-#{version}-py3-#{arch}.pkg",
      verified: "packages.broadcom.com/artifactory/saltproject-generic/"
  name "Salt #{version} LTS"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://packages.broadcom.com/artifactory/saltproject-generic/macos"
    regex(%r{href="3006\.\d+/">(3006\.\d+)}i)
  end

  conflicts_with formula: "salt"
  depends_on macos: ">= :big_sur"

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight do
    require_relative "../lib/patches/salt"
    %w[api master minion syndic].each { |daemon| Patches::Salt.patch_plist(daemon) }
  end

  uninstall launchctl: [
              "com.saltstack.salt.api",
              "com.saltstack.salt.master",
              "com.saltstack.salt.minion",
              "com.saltstack.salt.syndic",
            ],
            pkgutil:   "com.saltstack.salt"

  zap trash: "/etc/salt"

  def caveats
    <<~CAVEATS
      Included services:

      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.api.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.master.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.minion.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.syndic.plist
    CAVEATS
  end
end
