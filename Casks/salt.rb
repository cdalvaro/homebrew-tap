cask "salt" do
  arch arm: "arm64", intel: "x86_64"

  version "3007.1"
  sha256 arm:          "968b7701a470f5786474dea4489f96b546e7b6340ba734695b7899aa6edf14a2",
         intel:        "865d2d3792659ddbd48940b0e031a3e9652a85977cf0a2ef3a5ec00e34eb66cb",
         # linux sha256 hashes are invented
         x86_64_linux: "1a2aee7f1ddc999993d4d7d42a150c5e602bc17281678050b8ed79a0500cc90f",
         arm64_linux:  "bd766af7e692afceb727a6f88e24e6e68d9882aeb3e8348412f6c03d96537c75"

  url "https://packages.broadcom.com/artifactory/saltproject-generic/macos/#{version}/salt-#{version}-py3-#{arch}.pkg",
      verified: "packages.broadcom.com/artifactory/saltproject-generic/"
  name "Salt #{version} STS"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://packages.broadcom.com/artifactory/saltproject-generic/macos"
    regex(%r{href="\d+\.\d+/">(\d+\.\d+)}i)
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
