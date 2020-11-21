class Wxmac < Formula
  desc     "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url      "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.4/wxWidgets-3.1.4.tar.bz2"
  sha256   "3ca3a19a14b407d0cdda507a7930c2e84ae1c8e74f946e0144d2fa7d881f1a94"
  license  "wxWindows"
  revision 1
  head     "https://github.com/wxWidgets/wxWidgets.git"

  livecheck do
    url "https://github.com/wxWidgets/wxWidgets/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/wxmac-3.1.4_1"
    cellar :any
    sha256 "10d048b269014d0d1ce9365ff5cbdfe6cb76d81ff61226de8a9fa337a45fb601" => :catalina
  end

  option "with-enable-abort", "apply patch patch-make-public-enable-abort"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  if build.with?("enable-abort")
    patch do
      url "https://github.com/cdalvaro/homebrew-tap/raw/master/formula-patches/wxmac/patch-make-public-enable-abort.diff"
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
      "--enable-webkit",
      "--enable-webview",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
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
