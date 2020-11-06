class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://s.saltstack.com/community/"
  url "https://files.pythonhosted.org/packages/48/79/66352fd2351bd494ee6ee502693c8b54f77a8afc4d96c5b20b1f1306b2b5/salt-3002.1.tar.gz"
  sha256 "4c536a0577c9fe5052fa80c25c93527af00b50086aba0f5320e46dcd1dc3e75e"
  license "Apache-2.0"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.7"
  depends_on "zeromq"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Homebrew installs optional dependencies: M2Crypto, libgit2

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cffi" do
    # 1.12.2 is required here https://github.com/saltstack/salt/blob/998c382f5f2c3b4cbf7d96aa6913ada6993909b3/requirements/static/pkg/py3.7/darwin.txt#L10
    url "https://files.pythonhosted.org/packages/64/7c/27367b38e6cc3e1f49f193deb761fe75cda9f95da37b67b422e62281fcac/cffi-1.12.2.tar.gz"
    sha256 "e113878a446c6228669144ae8a56e268c91b7f1fafae927adc4879d9849e0ea7"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/ff/df/84609ed874b5e6fcd3061a517bf4b6e4d0301f553baf9fa37bef2b509797/M2Crypto-0.36.0.tar.gz"
    sha256 "1542c18e3ee5c01db5031d0b594677536963e3f54ecdf5315aeecb3a595b4dc1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/20/02/25077cf7ac6599e0e6bd2c6836e7c7360244d2d7224d54e51218dbe00711/pygit2-1.3.0.tar.gz"
    sha256 "0be93f6a8d7cbf0cc79ae2f0afb1993fc055fc0018c27e2bd01ba143e51d4452"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/56/1f/74c3e29389d34feea2d62ba3de1169efea2566eb22e9546d379756860525/importlib_metadata-2.0.0.tar.gz"
    sha256 "77a540690e24b0305878c37ffd421785a6f7e53c8b5720d211b211de8d0e95da"
  end

  # Do not install PyObjC since it causes broken linkage
  # Based on:
  # - https://github.com/Homebrew/homebrew-core/pull/52835#issuecomment-617502578
  # - https://github.com/saltstack/salt/pull/56904
  patch do
    #url "https://github.com/cdalvaro/homebrew-tap/raw/master/formula-patches/salt/remove-pyobjc-linkage.diff"
    url "file:///Users/Carlos/Documents/Projects/github/homebrew-tap/formula-patches/salt/remove-pyobjc-linkage.diff"
    sha256 "7808935308300d9679a3ed4153185408609cf0bdf22e4ec84d9055d0cf3f935c"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    # Fix building of M2Crypto on High Sierra https://github.com/Homebrew/homebrew-core/pull/45895
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    venv = virtualenv_create(libexec, Formula["python@3.7"].bin/"python3.7")
    venv.pip_install resources

    system libexec/"bin/pip", "install", "-v", "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "salt"
    venv.pip_install_and_link buildpath

    prefix.install libexec/"share" # man pages
    (etc/"saltstack").install (buildpath/"conf").children # sample config files
  end

  def caveats
    <<~EOS
      Sample configuration files have been placed in #{etc}/saltstack.
      Saltstack will not use these by default.

      Homebrew's installation does not include PyObjC.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salt --version")
  end
end
