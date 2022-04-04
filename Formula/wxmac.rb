class Wxmac < Formula
  desc     "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url      "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.6/wxWidgets-3.1.6.tar.bz2"
  sha256   "6a2339997794eb9964aa4e0985aa2b8614257d63bb5e422f8cd9363f0d376146"
  license  "wxWindows"
  head     "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url "https://github.com/wxWidgets/wxWidgets/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/wxmac-3.1.5"
    sha256 cellar: :any, big_sur:  "4dc49ed78e35b56ea14588df8e4ad8b17e8f55e90ca063bc62c8d215d770e017"
    sha256 cellar: :any, catalina: "5fdc5f5454b4ce673748e5e2cacb36858833f2c6e866cd02a7e54eda3004f4b5"
  end

  option "with-enable-abort", "apply patch patch-make-public-enable-abort"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

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
