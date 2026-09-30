cask "salt" do
  arch arm: "arm64", intel: "x86_64"

  version "3008.3"
  sha256 arm:   "906c3faebfcbf47a71db9b4472b956b858d96276e2b01e2cab763a5caa68b695",
         intel: "61c1a0af8ae7391d7c3be7f0dc158ffef75cd54be1bf9394ec567ec57ffe03d0"

  url "https://packages.broadcom.com/artifactory/saltproject-generic/macos/#{version}/salt-#{version}-py3-#{arch}.pkg"
  name "Salt #{version} LTS"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://packages.broadcom.com/artifactory/saltproject-generic/macos"
    regex(%r{href="\d+\.\d+/">(\d+\.\d+)}i)
  end

  depends_on :macos

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight_steps do
    run "/bin/sh",
        args:         [
          "-c",
          <<~SH,
            for daemon in api master minion syndic; do
              plist="/Library/LaunchDaemons/com.saltstack.salt.${daemon}.plist"
              plutil -insert EnvironmentVariables -dictionary "$plist" 2>/dev/null
              plutil -replace EnvironmentVariables.HOMEBREW_PREFIX -string "{{HOMEBREW_PREFIX}}" "$plist"
              plutil -replace EnvironmentVariables.PATH \\
                -string "{{HOMEBREW_PREFIX}}/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" "$plist"
            done
          SH
        ],
        sudo:         true,
        must_succeed: false
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
