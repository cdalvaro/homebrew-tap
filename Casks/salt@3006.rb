require "patches/salt"

cask "salt@3006" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.9"
  sha256 arm:   "81fca1bcd46eed09a6f5b97451a1238a6a78a97a1af6757cf6a73b2bb7b6db6d",
         intel: "5366e96e38073863522c2fc8097c97f7698a84c22f9899cbdf796b1e8b45b1e0"

  url "https://packages.broadcom.com/artifactory/saltproject-generic/macos/#{version}/salt-#{version}-py3-#{arch}.pkg",
      verified: "packages.broadcom.com/artifactory/saltproject-generic/"
  name "Salt #{version} LTS"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://packages.broadcom.com/artifactory/saltproject-generic/macos"
    regex(/href="3006\.\d+">(3006\.\d+)/i)
  end

  conflicts_with formula: "salt"

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight do
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
