cask 'salt' do
  arch arm: 'arm64', intel: 'x86_64'

  version '3006.1'
  sha256 arm: '',
         intel: '21b3dafd8b3e2dd8e4fe7c63dcddec8faac94b953904ffd74ac1cc8f027498a1'

  url "https://repo.saltproject.io/salt/py3/macos/minor/#{version}/salt-#{version}-py3-#{arch}.pkg"
  name 'Salt'
  desc 'Salt is the world’s fastest, most intelligent and scalable automation engine'
  homepage 'https://saltproject.io'

  livecheck do
    url 'https://repo.saltproject.io/salt/py3/macos/'
    regex(%r{(\d+(?:\.\d+)?(?:-\d+)?)/})
  end

  pkg "salt-#{version}-py3-#{arch}.pkg"

  on_arm do
    postflight do
      temp_dir = Pathname(Dir.mktempdir)
      %w[api master minion syndic].each do |daemon|
        plist_file = "/Library/LaunchDaemons/com.saltstack.salt.#{daemon}.plist"
        p "Modifying #{plist_file}"
        next unless File.exist?(plist_file)

        FileUtils.makedirs temp_dir
        mod_plist_file = temp_dir.join(File.basename(plist_file))
        FileUtils.copy plist_file, mod_plist_file

        path = `plutil -extract EnvironmentVariables.PATH raw -expect string -n "#{mod_plist_file}"`
        next unless $?.success?

        system 'putil', '-replace', 'EnvironmentVariables.PATH', '-string', "#{HOMEBRE_PREFIX.to_s}/bin:#{path}", mod_plist_file
        next unless $?.success?

        system 'plutil', '-insert', 'EnvironmentVariables.HOMEBREW_PREFIX', '-string', HOMEBREW_PREFIX.to_s, mod_plist_file
        next unless $?.success?

        FileUtils.move mod_plist_file, plist_file
      end
    end
  end

  uninstall pkgutil: [
              'com.saltstack.salt'
            ],
            launchctl: [
              'com.saltstack.salt.*'
            ]

  zap trash: [
    '/etc/salt'
  ]

  def caveats
    <<~CAVEATS
      After installation, configure the Salt minion ID, and the Salt master location,
      replacing the placeholder text with custom information:

      sudo salt-config -i [MINION_ID] -m [SALT_MASTER_HOST]

      See Configure the Salt master and minions for more configuration options:
      https://docs.saltproject.io/salt/install-guide/en/latest/topics/configure-master-minion.html

      Load services you need:

      sudo launchctl load -w com.saltstack.salt.api
      sudo launchctl load -w com.saltstack.salt.master
      sudo launchctl load -w com.saltstack.salt.minion
      sudo launchctl load -w com.saltstack.salt.syndic
    CAVEATS
  end
end
