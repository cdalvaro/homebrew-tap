cask "salt@3006" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.10"

  on_macos do
    sha256 arm:   "068e1d1eb3eba60909688b03956e368c4203210b013d4dfd1ff4067aa3c262bf",
           intel: "4a2f2e4235c7c0764626ddd6b52990ab043ab143916ec488b8b2a03c0755bd70"
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
