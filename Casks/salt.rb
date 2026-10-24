cask "salt" do
  arch arm: "arm64", intel: "x86_64"

  version "3008.4"
  sha256 arm:   "bb2557a21b2b1dbfb17f2be6acc10e8b50d29b73b57a2906868f7768854c1085",
         intel: "d2a3643c44d66dd2a0f50392cc0e071d40bf067d300121cabbb2f500ddb4afb1"

  url "https://github.com/saltstack/salt/releases/download/v#{version}/salt-#{version}-py3-#{arch}.pkg"
  name "Salt #{version} LTS"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url :url
    regex(/^v?(\d+\.\d+(?:-\d+)?)$/i)
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
