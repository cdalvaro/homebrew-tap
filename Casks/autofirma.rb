cask "autofirma" do
  arch arm: "M1", intel: "x64"
  pkg_arch = on_arch_conditional arm: "aarch64", intel: "x64"

  version "1.8.4"
  sha256 arm:          "2ffbf235fe0ff77c72707c674a67d4ffb924c05eca5910c7478dc96069c900a9",
         intel:        "a14b6203d597cd113a2f53d587d657320632011b29cea1fbeadfd663140bcbed",
         # linux sha256 hashes are invented
         x86_64_linux: "1a2aee7f1ddc999993d4d7d42a150c5e602bc17281678050b8ed79a0500cc90f",
         arm64_linux:  "bd766af7e692afceb727a6f88e24e6e68d9882aeb3e8348412f6c03d96537c75"

  url "https://estaticos.redsara.es/comunes/autofirma/#{version.major}/#{version.minor}/#{version.patch}/AutoFirma_Mac_#{arch}.zip",
      verified: "estaticos.redsara.es/comunes/autofirma/"
  name "AutoFirma"
  desc "Digital signature editor and validator"
  homepage "https://firmaelectronica.gob.es/Home/Descargas.html"

  livecheck do
    url :homepage
    regex(%r{autofirma/(\d+)/(\d+)/(\d+)/AutoFirma[._-]Mac[._-]#{arch}\.zip}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]}.#{match[1]}.#{match[2]}" }
    end
  end

  depends_on macos: ">= :big_sur"

  pkg "AutoFirma_#{version.dots_to_underscores}_#{pkg_arch}.pkg"

  # remove 'Autofirma ROOT' certificates from keychain
  uninstall_postflight do
    ["AutoFirma ROOT", "127.0.0.1"].each do |cert|
      stdout, * = system_command "/usr/bin/security",
                                 args: ["find-certificate", "-a", "-c", cert, "-Z"],
                                 sudo: true
      hashes = stdout.lines.grep(/^SHA-256 hash:/) { |l| l.split(":").second.strip }
      hashes.each do |h|
        puts "Removing certificate #{cert} (#{h})"
        system_command "/usr/bin/security",
                       args: ["delete-certificate", "-Z", h],
                       sudo: true
      end
    end
  end

  uninstall quit:    "es.gob.afirma",
            pkgutil: "es.gob.afirma",
            delete:  "/Applications/AutoFirma.app"

  zap trash: [
    "~/.afirma",
    "~/Library/Application Support/AutoFirma",
    "~/Library/Preferences/es.gob.afirma.plist",
  ]
end
