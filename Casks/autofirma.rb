cask "autofirma" do
  arch arm: "M1", intel: "x64"
  pkg_arch = on_arch_conditional arm: "aarch64", intel: "x64"

  version "1.8.3"
  sha256 arm:   "5cdf749402cde3a556b048ec7102a5e428aaf422f5fe22f908c2234c99db6164",
         intel: "624b8b42839c4ff4241a9146db1a75437551dde265f85b5b90351d13b179df4e"

  url "https://estaticos.redsara.es/comunes/autofirma/#{version.major}/#{version.minor}/#{version.patch}/AutoFirma_Mac_#{arch}.zip",
      verified: "estaticos.redsara.es/comunes/autofirma/"
  name "AutoFirma"
  desc "Digital signature editor and validator"
  homepage "https://firmaelectronica.gob.es/Home/Descargas.html"

  livecheck do
    url :url
    strategy :extract_plist
  end

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
