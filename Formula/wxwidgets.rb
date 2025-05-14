class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.8/wxWidgets-3.2.8.tar.bz2"
  sha256 "c74784904109d7229e6894c85cfa068f1106a4a07c144afd78af41f373ee0fe6"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any,                 arm64_sequoia: "16fe679db1d6e4339a3358ff6974e2549a2799be7819065e0f7988e786b086a3"
    sha256 cellar: :any,                 arm64_sonoma:  "3e8a0446365e6f88710e5ff113d9dd1868696452759b79aeb4284921209436bf"
    sha256 cellar: :any,                 ventura:       "10cf2abafaf7a8ade5bf20cb44993dfdc6b63386f8205926d0fd0858ae495565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5d14aad57b72ffce7b140d270d45883e3af0795d5a586333a401fc5e733b05"
  end

  option "with-enable-abort", "Allows to abort a wxProgressDialog"

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
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
      "--with-zlib",
      "--disable-dependency-tracking",
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

      # Work around deprecated Carbon API, see
      # https://github.com/wxWidgets/wxWidgets/issues/24724
      inreplace "src/osx/carbon/dcscreen.cpp", "#if !wxOSX_USE_IPHONE", "#if 0" if MacOS.version >= :sequoia
    end

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace bin/"wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink bin/"wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
