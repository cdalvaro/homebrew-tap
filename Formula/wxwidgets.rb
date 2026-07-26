class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.11/wxWidgets-3.2.11.tar.bz2"
  sha256 "6a129015bce2e914e4bf61ec4411854ad962801d47e92f2eb8340adb6a90af08"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(3\.2(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any, arm64_tahoe:   "f6aaa39b0279f6c4678a66dff01cddad9f940a4d9213fbc115526a4070b902e6"
    sha256 cellar: :any, arm64_sequoia: "7c8102d7963021e6d1f264353df9ca7d4e990eea4ea3e8d824c6857cd273a979"
    sha256 cellar: :any, arm64_sonoma:  "fa6c52fd2e7964d3746167e16edea5db02d5d1231810a5104aea14a87a45d4d8"
    sha256 cellar: :any, x86_64_linux:  "4ee0b5115516f6b9eeec453bb487a69b3f8bd6c7a4e0012366b54aa2d8619b22"
  end

  option "with-enable-abort", "Allows to abort a wxProgressDialog"

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"

  uses_from_macos "expat"

  on_linux do
    depends_on "cairo"
    depends_on "fontconfig"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "libxtst"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "pango"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
  end

  resource "enable_abort" do
    url "https://raw.githubusercontent.com/cdalvaro/homebrew-tap/55724bef53cb80b9d6019f50cc915101c460bc48/patches/wxwidgets/enable_abort.diff"
    sha256 "2c14fb49da7ab4144fba1793fde80eedcb6201d7bf765d9c1c17b1f0b90851c8"
  end

  def install
    if build.with? "enable-abort"
      resource("enable_abort").stage do
        system "patch", "-p1", "-d", buildpath, "-i", "#{pwd}/enable_abort.diff"
      end
    end

    # Remove all bundled libraries excluding `nanosvg` which isn't available as formula
    %w[catch pcre].each { |l| rm_r(buildpath/"3rdparty"/l) }
    %w[expat jpeg png tiff zlib].each { |l| rm_r(buildpath/"src"/l) }

    args = [
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
      "--with-zlib",
      "--disable-tests",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if OS.mac?
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace bin/"wx-config", prefix, HOMEBREW_PREFIX

    # Move some files out of the way to prevent conflict with `wxwidgets`
    (bin/"wxrc").unlink
    bin.install bin/"wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  def caveats
    <<~EOS
      To avoid conflicts with the wxwidgets formula, `wx-config` and `wxrc`
      have been installed as `wx-config-#{version.major_minor}` and `wxrc-#{version.major_minor}`.
    EOS
  end

  test do
    system bin/"wx-config-#{version.major_minor}", "--libs"
  end
end
