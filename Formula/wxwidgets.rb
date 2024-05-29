class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.5/wxWidgets-3.2.5.tar.bz2"
  sha256 "0ad86a3ad3e2e519b6a705248fc9226e3a09bbf069c6c692a02acf7c2d1c6b51"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/wxwidgets-3.2.4"
    sha256 cellar: :any,                 ventura:      "41e27b329a45192e790f14c795058d4d4c433f973e644ad9db65ba40315d4087"
    sha256 cellar: :any,                 monterey:     "492221be386762da96c3d9f27f431eac72eab0ac9b3fc4971a91d80c0b2d69f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1ddae289be426a2ec243cbb6dfd7cbedb692b3f94bb3201931f6fafd5d5d3347"
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

  patch :DATA if build.with?("enable-abort")

  def install
    # Remove all bundled libraries excluding `nanosvg` which isn't available as formula
    %w[catch pcre].each { |l| (buildpath/"3rdparty"/l).rmtree }
    %w[expat jpeg png tiff zlib].each { |l| (buildpath/"src"/l).rmtree }

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
diff --git a/include/wx/generic/progdlgg.h b/include/wx/generic/progdlgg.h
index ba8fb0bcc5198affee86b47a0d5342457607c1b2..f14b5909c0ccf8eaf0705ea9e48d6659942e7148 100644
--- a/include/wx/generic/progdlgg.h
+++ b/include/wx/generic/progdlgg.h
@@ -174,7 +174,9 @@ private:
     // shortcuts for enabling buttons
     void EnableClose();
     void EnableSkip(bool enable = true);
-    void EnableAbort(bool enable = true);
+public:
+    virtual void EnableAbort(bool enable = true);
+private:
     void DisableSkip() { EnableSkip(false); }
     void DisableAbort() { EnableAbort(false); }

diff --git a/include/wx/msw/progdlg.h b/include/wx/msw/progdlg.h
index c22a79db91ba210fcc7329c3be4f3ad34287ca8b..dcd201aaef0b98653a0c853962032ee1277d2379 100644
--- a/include/wx/msw/progdlg.h
+++ b/include/wx/msw/progdlg.h
@@ -54,6 +54,8 @@ public:

     virtual WXWidget GetHandle() const wxOVERRIDE;

+    virtual void EnableAbort(bool enable = true) wxOVERRIDE;
+
 private:
     // Common part of Update() and Pulse().
     //
diff --git a/interface/wx/progdlg.h b/interface/wx/progdlg.h
index 28ce778ed61d85bf7aae59e6a3d44290b54dd7c2..e0ada14805f1fe9f80b91994fc0b12d14ae65a5b 100644
--- a/interface/wx/progdlg.h
+++ b/interface/wx/progdlg.h
@@ -243,6 +243,14 @@ public:
     */
     virtual bool Update(int value, const wxString& newmsg = wxEmptyString,
                         bool* skip = NULL);
+
+    /**
+        Enables or disables de cancel/abort button
+
+        @param enable
+            True then the progress dialog can be cancelled, false otherwise
+    */
+    virtual void EnableAbort(bool enable = true);
 };


diff --git a/src/msw/progdlg.cpp b/src/msw/progdlg.cpp
index 8525a85dba2b2881e8d7e76a994117a7e4718afd..9c4572b4cf23457df29a54f3884b274322e62edd 100644
--- a/src/msw/progdlg.cpp
+++ b/src/msw/progdlg.cpp
@@ -761,6 +761,18 @@ bool wxProgressDialog::WasCancelled() const
     return wxGenericProgressDialog::WasCancelled();
 }

+void wxProgressDialog::EnableAbort(bool enable) {
+#ifdef wxHAS_MSW_TASKDIALOG
+    if ( HasNativeTaskDialog() )
+    {
+        wxCriticalSectionLocker locker(m_sharedData->m_cs);
+        if ( !(sharedData->m_style & wxPD_CAN_ABORT) )
+            EnableCloseButtons(m_sharedData->m_hwnd, enable);
+    }
+#endif // wxHAS_MSW_TASKDIALOG
+    wxGenericProgressDialog::EnableAbort(enable);
+}
+
 void wxProgressDialog::SetTitle(const wxString& title)
 {
 #ifdef wxHAS_MSW_TASKDIALOG
