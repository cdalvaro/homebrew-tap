class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.9/wxWidgets-3.2.9.tar.bz2"
  sha256 "fb90f9538bffd6a02edbf80037a0c14c2baf9f509feac8f76ab2a5e4321f112b"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "625fa883e50fceb4faec8bba3d1da62a6a87cdcd028e7e30660857ea292a6afc"
    sha256 cellar: :any,                 arm64_sequoia: "db6d4f3a88051b33410b5aa4bacaafc67a6aee5a630edf0a0a596bdaaf9bbbef"
    sha256 cellar: :any,                 arm64_sonoma:  "6c373a3a54dcd6a20a370b6c20cca4cf0f2afcb7c1383a9cb15bd3c1f6abdb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d94ab22e86ffbec8ce8cae2cfcdf0b623a220a95cf180b122a61bb642de001f"
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
