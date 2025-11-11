class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.8.1/wxWidgets-3.2.8.1.tar.bz2"
  sha256 "ad0cf6c18815dcf1a6a89ad3c3d21a306cd7b5d99a602f77372ef1d92cb7d756"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any,                 arm64_sequoia: "c11a2efda00c13c9cf8c1dfe1dfedb7e3b701a273a404989b72c4d2fb6545b25"
    sha256 cellar: :any,                 arm64_sonoma:  "2145bacd7a22a067406ff2a23f70d36831f38d4ca83a08c222e2322205f15a72"
    sha256 cellar: :any,                 ventura:       "c2859af7745981423e349ac9e922f01cfb73f88de0208a7d2cd32a2e05cd3c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b366fa7ed962f8331f4d08e8d0c0c86b6ba7c4ccec16e30c639f142bfe035e58"
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

  # Fix an unnecessary link against Framework AGL, which has been removed in macOS 26
  # https://github.com/wxWidgets/wxWidgets/pull/25799
  patch :DATA

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

__END__
diff --git i/configure w/configure
index 41c9466d48..dca0812c20 100755
--- i/configure
+++ w/configure
@@ -32397,7 +32397,7 @@ if test "$wxUSE_OPENGL" = "yes" -o "$wxUSE_OPENGL" = "auto"; then


     if test "$wxUSE_OSX_COCOA" = 1; then
-        OPENGL_LIBS="-framework OpenGL -framework AGL"
+        OPENGL_LIBS="-framework OpenGL"
     elif test "$wxUSE_MSW" = 1; then
         OPENGL_LIBS="-lopengl32 -lglu32"
     elif test "$wxUSE_MOTIF" = 1 -o "$wxUSE_X11" = 1 -o "$wxUSE_GTK" = 1 -o "$wxUSE_QT" = 1; then
diff --git i/configure.in w/configure.in
index d2775343b5..69e7f7d584 100644
--- i/configure.in
+++ w/configure.in
@@ -3871,7 +3871,7 @@ if test "$wxUSE_OPENGL" = "yes" -o "$wxUSE_OPENGL" = "auto"; then
     dnl look in glcanvas.h for the list of platforms supported by wxGlCanvas:

     if test "$wxUSE_OSX_COCOA" = 1; then
-        OPENGL_LIBS="-framework OpenGL -framework AGL"
+        OPENGL_LIBS="-framework OpenGL"
     elif test "$wxUSE_MSW" = 1; then
         OPENGL_LIBS="-lopengl32 -lglu32"
     elif test "$wxUSE_MOTIF" = 1 -o "$wxUSE_X11" = 1 -o "$wxUSE_GTK" = 1 -o "$wxUSE_QT" = 1; then
