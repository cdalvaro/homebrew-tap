class Sshfs < Formula
  desc     "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url      "https://github.com/libfuse/sshfs/archive/sshfs-3.5.2.tar.gz"
  sha256   "ea32f71225b7ba507e29eff4b0592c6e877ac8411ba10ec0e30b0c8a43f3fbae"
  head     "https://github.com/libfuse/sshfs.git"
  bottle   :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :osxfuse

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
