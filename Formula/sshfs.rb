class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/sshfs-3.7.2.tar.gz"
  sha256 "8a9b0d980e9d34d0d18eacb9e1ca77fc499d1cf70b3674cc3e02f3eafad8ab14"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", ".."
      system "meson", "configure", "--prefix", prefix
      system "ninja", "--verbose"
      system "ninja", "install", "--verbose"
    end
  end

  def caveats
    <<~EOS
      This formula requires macfuse in order to work.
      Install macfuse before installing sshfs:

        brew install --cask macfuse
    EOS
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
