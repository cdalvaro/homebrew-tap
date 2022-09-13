class Wxmac < Formula
  desc     "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.1/wxWidgets-3.2.1.tar.bz2"
  sha256 "c229976bb413eb88e45cb5dfb68b27890d450149c09b331abd751e7ae0f5fa66"
  license  "wxWindows"
  head     "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/wxmac-3.2.1"
    sha256 cellar: :any, monterey: "954545aef13c7811d55c643b131d1177aace2d88f7c2e190191b14602d158ff6"
    sha256 cellar: :any, big_sur:  "79357ea26f31289cffd2435ec24da72249b554c07cae83194654456c836d96c6"
    sha256 cellar: :any, catalina: "279156de73edd6cd611f991f6cda9c0efbfb2b1a04b9a775b82f39a2b477c78e"
  end

  option "with-enable-abort", "apply patch patch-make-public-enable-abort"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  if build.with?("enable-abort")
    patch do
      url "https://github.com/cdalvaro/homebrew-tap/raw/HEAD/formula-patches/wxmac/patch-make-public-enable-abort.diff"
      sha256 "50c4fd7618cc6015dafc55a89d96f5330dc739215a1c55f31c4d34181b5e5d18"
    end
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webviewwebkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx",
      "--with-zlib",
      "--with-libcurl",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
      "--disable-tests",
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
    ]

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
