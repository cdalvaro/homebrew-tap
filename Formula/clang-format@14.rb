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
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/clang-format@14-14.0.6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "c42b9a057f2dd44e0236ef3038895785d1103fbfbd92d47441df369e1efaff1a"
    sha256 cellar: :any_skip_relocation, ventura:      "a6edc464bca70ccdffc602d427a1a2cd92abb5cce6b968aa4c098f40f1f1cd81"
    sha256 cellar: :any_skip_relocation, monterey:     "e1d9b7db2bc019ea004e51508a8913d5b4a5c71a30c6ead8e74bff00258bfeeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aa609dcd859a9dc046a2c48858fde5ab8cf792632781c509fef0f79639637457"
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
