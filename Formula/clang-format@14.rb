class ClangFormatAT14 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/llvm-14.0.6.src.tar.xz"
  sha256 "050922ecaaca5781fdf6631ea92bc715183f202f9d2f15147226f023414f619a"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3689dc1728478966f5bf62dc49d8053112fcdba191c26c3e1f38ce736457da72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b583c1294ebd5229b0680a8a84889b8cd079285f495bc78ae2dd5893b5b3521f"
    sha256 cellar: :any_skip_relocation, ventura:       "048de52d859b6a7b2db79c2f785422e3b6f481f5da21262084e59c4ce9a2508e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f65cfc80a6cb4ff79368fbfb18c400ebb316414544380c16dc66f39e737dedb5"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  resource "clang" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/clang-14.0.6.src.tar.xz"
    sha256 "2b5847b6a63118b9efe5c85548363c81ffe096b66c3b3675e953e26342ae4031"
  end

  def install
    resource("clang").stage do |r|
      (buildpath/"llvm-#{version}.src/tools/clang").install Pathname("clang-#{r.version}.src").children
    end

    llvmpath = buildpath/"llvm-#{version}.src"

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    git_clang_format = llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    inreplace git_clang_format, %r{^#!/usr/bin/env python$}, "#!/usr/bin/env python3"

    bin.install buildpath/"build/bin/clang-format" => "clang-format-14"
    bin.install git_clang_format => "git-clang-format-14"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-14 -style=Google test.c")
  end
end
