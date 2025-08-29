cask "salt@lts" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.15"

  on_macos do
    sha256 arm:   "893e70fe20c331faaff08655a595735e030bad73f6d426e4e2d59bab82e0677c",
           intel: "bff74b235f9feb9f52cc55f8cbc9276386df7d78b7c9e6ba9f4182362d67de05"
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

  caveats do
    <<~CAVEATS
      Included services:

      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.api.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.master.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.minion.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.syndic.plist
    CAVEATS
  end
end
