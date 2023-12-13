class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://saltproject.io/"
  url "https://files.pythonhosted.org/packages/6a/a3/6a7c402ea662fb551a76f7038eb2a02d78437b5afd1baeec99dc03d57b94/salt-3006.5.tar.gz"
  sha256 "6f9687f2542ddc8084b17cb47f0a4cafd48940123ba3ed5731f6aa81fe7f973e"
  license "Apache-2.0"
  head "https://github.com/saltstack/salt.git", branch: "master"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/salt-3006.4"
    sha256 cellar: :any,                 arm64_sonoma: "306d80330bf6d06532066ce196b2f2d90d4d6d34b0e55f67ba51ec656faa8bfd"
    sha256 cellar: :any,                 ventura:      "f33f66c2266ab2323ea08696f2a6e205a447a3f9d1539fed841e82acaab58b39"
    sha256 cellar: :any,                 monterey:     "515f48e403ed89f58a62ad4000a59ed65924f61d6910abffef5e9424ad86d00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ebb4e2d7872626c3460bd4f6d92a3d05977609c3d3f9d71cc5ba5538b976e30a"
  end

  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.10"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gmp"
    depends_on "pcre"
  end

  # Homebrew installs optional dependencies: pycryptodome, pygit2

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/b6/a0/707142df518a602a2e36f9aa4f6dcc2cc9981843ffb7ba1207f7a084819d/apache-libcloud-2.5.0.tar.gz"
    sha256 "8f133038710257d39f9092ccaea694e31f7f4fe02c11d7fcc2674bc60a9448b6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/0e/77/0f823e39f78d97706b11cefc4b95829a2ca237a3021a37a6b7ec361b2113/cheroot-8.5.2.tar.gz"
    sha256 "f137d03fd5155b1364bea557a7c98168665c239f6c8cedd8f80e81cdfac01567"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/c6/0d/f6acfd12f098b9f05b9146b79b5a3fad02f4047a7831b5f5c9ee3fe54d56/CherryPy-18.6.1.tar.gz"
    sha256 "f33e87286e7b3e309e04e7225d8e49382d9d7773e6092241d7f613893c563495"
  end

  resource "contextvars" do
    url "https://files.pythonhosted.org/packages/83/96/55b82d9f13763be9d672622e1b8106c85acb83edd7cc2fa5bc67cd9877e9/contextvars-2.4.tar.gz"
    sha256 "f38c908aaa59c14335eeea12abea5f443646216c4e29380d7bf34d2018e2c39e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ce/b3/13a12ea7edb068de0f62bac88a8ffd92cc2901881b391839851846b84a81/cryptography-41.0.7.tar.gz"
    sha256 "13f93ce9bea8016c253b34afc6bd6a75993e5c40672ed5405a9c832f0d4a00bc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/0d/b2/37265877ae607a2cbf9a471f4581dbf5ed13a501b90cb4c773f9ccfff3ea/GitPython-3.1.40.tar.gz"
    sha256 "22b126e9ffb671fdd0c129796343a02bf67bf2994b35449ffc9321aa755e18a4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "immutables" do
    url "https://files.pythonhosted.org/packages/d5/33/1187e0fcc0a521a72234b011e06cff99f8a204e1125ea791c190bd780de7/immutables-0.15.tar.gz"
    sha256 "3713ab1ebbb6946b7ce1387bb9d1d7f5e09c45add58c2a2ee65f963c171e746b"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/30/3b/83a992fe6db1dd8de6e88cffa9481516e6984d63983f88cc031fe1bb992d/importlib_metadata-6.0.1.tar.gz"
    sha256 "950127d57e35a806d520817d3e92eec3f19fdae9f0cd99da77a407c5aabefba3"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "jaraco-collections" do
    url "https://files.pythonhosted.org/packages/d9/f8/da1c43345aa1ce0a98391497719cfc80d9664727431554a6aab5328481eb/jaraco.collections-3.4.0.tar.gz"
    sha256 "344d14769d716e7496af879ac71b3c6ebdd46abc64bd9ec21d15248365aa3ac9"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/a9/1e/44f6a5cffef147a3ffd37a748b8f4c2ded9b07ca20a15f17cd9874158f24/jaraco.functools-2.0.tar.gz"
    sha256 "35ba944f52b1a7beee8843a5aa6752d1d5b79893eeb7770ea98be6b637bf9345"
  end

  resource "jaraco-text" do
    url "https://files.pythonhosted.org/packages/53/d2/40ff557369eccee312b2d3ff4cb97373e8ffb25afb92294ff650a1e45795/jaraco.text-3.5.1.tar.gz"
    sha256 "ede4e9103443b62b3d1d193257dfb85aab7c69a6cef78a0887d64bb307a03bc3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "linode-python" do
    url "https://files.pythonhosted.org/packages/4b/74/e488eb310b266e679e9e5095563be08185f2923802fb87be8f5cad652b74/linode-python-1.1.1.tar.gz"
    sha256 "5078aae54a5f6f325ac8cd47c3baa2582546d51b7060a0f9f6ad851027817bc0"
  end

  resource "looseversion" do
    url "https://files.pythonhosted.org/packages/0e/e8/f18d7af585a2cc948a26b5e2dedc69729213d201525f79685050f6d621a5/looseversion-1.0.3.tar.gz"
    sha256 "035288860e1afe67d63ea9c700dd9d095c724e2e5722a39029dd91652d4316ed"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a0/47/6ff6d07d84c67e3462c50fa33bf649cda859a8773b53dc73842e84455c05/more-itertools-8.2.0.tar.gz"
    sha256 "b1ddb932186d8a6ac451e1d95844b382f55e12686d51ca0c68b6f61f2ab7a507"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "portend" do
    url "https://files.pythonhosted.org/packages/04/98/997f8668b11292f13d3e69fc626232c497228306c764523c5a3a3b59c775/portend-2.6.tar.gz"
    sha256 "600dd54175e17e9347e5f3d4217aa8bcf4bf4fa5ffbc4df034e5ec1ba7cdaff5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/1a/72/acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025b/pycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/90/f4a934bffae029e16fb33f3bd87014a0a18b4bec591249c4fc01a18d3ab6/pycryptodomex-3.9.9.tar.gz"
    sha256 "7b5b7c5896f8172ea0beb283f7f9428e0ab88ec248ce0a5b8c98d73e26267d51"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/09/50/f0795db653ceda94f4388d2b40598c188aa4990715909fabcf16b381b843/pygit2-1.13.3.tar.gz"
    sha256 "0257c626011e4afb99bdb20875443f706f84201d4c92637f02215b98eac13ded"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-gnupg" do
    url "https://files.pythonhosted.org/packages/c8/cb/46fb80639cf0dd4251aeb075a1a5e2ebbb8c9656f28ddfe9d8c99b68b6da/python-gnupg-0.4.9.tar.gz"
    sha256 "aaa748795572591aaf127b4ac8985684f3673ff82b39f370c836b006e68fc537"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/72/37/d5603f352522e249e44ee767a8a59b3fe7cf7f708a94fd40a637c6890add/pyzmq-23.2.1.tar.gz"
    sha256 "2b381aa867ece7d0a82f30a0c7f3d4387b7cf2e0697e33efaa5bed6c5784abcd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/dd/d4/2b4f196171674109f0fbb3951b8beab06cd0453c1b247ec0c4556d06648d/smmap-4.0.0.tar.gz"
    sha256 "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182"
  end

  resource "tempora" do
    url "https://files.pythonhosted.org/packages/86/4e/9af10e9b896c70ac6e817ac317107f96efbe0b435c4918edd5bf6fcaa330/tempora-4.1.2.tar.gz"
    sha256 "fd6cafd66b01390d53a760349cf0b3123844ec6ae3d1043d7190473ea9459138"
  end

  resource "timelib" do
    url "https://files.pythonhosted.org/packages/05/5d/fb7fb8f50c85913ee3a2b10bf21c6f85b4195223ddbe36da064932a17e9b/timelib-0.2.5.zip"
    sha256 "6ac9f79b09b63bbc07db88525c1f62de1f6d50b0fd9937a0cb05e3d38ce0af45"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "vultr" do
    url "https://files.pythonhosted.org/packages/ea/87/abe6e282bb4797f37fba197f0bd61f8d05f4f0b1158931124837e5ea1cff/vultr-1.0.1.tar.gz"
    sha256 "3f38849d267808c02fb2b2d9d2e394cb0be5b2d5b422b34bda01c4544060de1b"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881/zc.lockfile-2.0.tar.gz"
    sha256 "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/1f/29/54ba1934c45af649698410456fa8a78a475c82efd5c562e51011079458d1/zipp-3.12.1.tar.gz"
    sha256 "a3cac813d40993596b39ea9e93a18e8a2076d5c378b8bc88ec32ab264e04ad02"
  end

  def install
    ENV["SWIG_FEATURES"] = "-I#{Formula["openssl@3"].opt_include}"

    virtualenv_install_with_resources

    prefix.install libexec / "share" # man pages
    (etc / "saltstack").install (buildpath / "conf").children # sample config files
  end

  def caveats
    <<~EOS
      Sample configuration files have been placed in #{etc}/saltstack.
      Saltstack will not use these by default.
    EOS
  end

  service do
    run [opt_bin / "salt-minion", "--config-dir=#{etc}/saltstack", "--pid-file=#{var}/run/salt-minion.pid"]
    log_path var / "log/salt-minion.log"
    error_log_path var / "log/salt-minion.log"
  end

  test do
    output = shell_output("#{bin}/salt --config-dir=#{testpath} --log-file=/dev/null --versions")
    assert_match "Salt: #{version}", output
    assert_match "Python: #{Formula["python@3.10"].version}", output
    assert_match "libgit2: #{Formula["libgit2"].version}", output
    assert_match "M2Crypto: Not Installed", output
  end
end
