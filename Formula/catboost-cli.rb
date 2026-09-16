# Shared by the catboost-derived formulae (catboost-cli, catboostmodel-cpp).
# Kept inline (not required from a separate lib file) because Homebrew only
# snapshots this single formula file into the keg's `.brew/<name>.rb`, used as
# a fallback loader once the tap is no longer resolvable (e.g. after
# `brew untap`); a `require_relative` to an external file breaks that load.
module CatboostConanToolchain
  module_function

  # Their CMake build forces `build/toolchains/clang.toolchain`, but Homebrew
  # defaults to GCC on Linux, so the shim silently swaps in `g++` whenever the
  # toolchain invokes `clang++`, which then chokes on Clang-only flags. Once we
  # switch to the real LLVM clang, Conan's bundled `settings.yml` may still not
  # recognize that LLVM release, so we register it via `settings_user.yml`,
  # Conan's supported mechanism for extending settings without patching the
  # bundled file.
  def fix_linux_clang!
    return unless OS.linux?

    ENV.llvm_clang

    conan_home = Pathname.new(Utils.safe_popen_read("conan", "config", "home").strip)
    (conan_home/"settings_user.yml").write <<~YAML
      compiler:
        clang:
          version: ["#{Formula["llvm"].version.major}"]
    YAML
  end
end

class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost.git",
    tag:      "v1.2.10",
    revision: "b1bd2a6d77219e82a1acfcedfccb8e6f6c1ee084"
  license "Apache-2.0"
  revision 1
  head "https://github.com/catboost/catboost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.2.10_1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9413bf0777979999dc18ca89a3124d2c5d2fa56bafe43c389717fd5c7a0dded8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "651af4b66b3565123fd5bf721cfad286350720fa6e159e6660285051de1910b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd988be636e7abcdd00fbe175014cb5ad2da20a59b20a352c4543b36a89db6b8"
    sha256                               x86_64_linux:      "583e65610870b77f0ceee88a675d61919181f9369d091d8d8f3d7e5576fd3991"
  end

  depends_on "cmake" => :build
  depends_on "conan" => :build
  depends_on "ninja" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "lld"
    depends_on "openssl@3.0"

    patch :DATA
  end

  resource "testdata" do
    url "https://github.com/catboost/tutorials.git",
        branch:   "master",
        revision: "b85bed6b57feafc84e3984872260f9888c9f3bae"
  end

  def install
    CatboostConanToolchain.fix_linux_clang!

    # Replace openssl::openssl by OpenSSL::SSL
    # Otherwise target_link_libraries fails
    Dir.glob("**/CMakeLists.*.txt") do |file|
      content = File.read(file)
      if content.include?("openssl::openssl")
        content.gsub!("openssl::openssl", "OpenSSL::SSL")
        File.write(file, content)
      end
    end

    cmake_project_top_level_includes = ["#{buildpath}/cmake/conan_provider.cmake"]

    # Check if CMAKE_PROJECT_TOP_LEVEL_INCLUDES is already specified in std_cmake_args
    cmake_top_level_includes = std_cmake_args.find { |arg| arg.start_with?("-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=") }
    if cmake_top_level_includes
      cmake_project_top_level_includes.unshift(cmake_top_level_includes.split("=")[1])
      std_cmake_args.delete(cmake_top_level_includes)
    end

    args = [
      "-DCATBOOST_COMPONENTS=app",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=On",
      "-DHAVE_CUDA=no",
      "-DCMAKE_TOOLCHAIN_FILE=#{buildpath}/build/toolchains/clang.toolchain",
      "-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=#{cmake_project_top_level_includes.join(";")}",
    ]

    cmakepath = buildpath/"cmake-build"
    system "cmake", "-S", ".", "-B", cmakepath, "-G", "Ninja", *std_cmake_args, *args
    system "ninja", "-C", cmakepath, "catboost"
    bin.install cmakepath/"catboost/app/catboost"
  end

  test do
    assert_match %r{Branch: tags/v#{version}}, shell_output("#{bin}/catboost --version")

    resource("testdata").stage do
      cd "cmdline_tutorial" do
        system bin/"catboost", "fit", "--learn-set", "train.tsv", "--test-set", "test.tsv", "--column-description",
"train.cd", "--loss-function", "RMSE", "--iterations", "1000", "--seed", 1, "--verbose", "0"
        system bin/"catboost", "calc", "-m", "model.bin", "--input-path", "test.tsv", "--cd", "train.cd", "-o",
"eval.tsv", "-T", "1", "--output-columns", "DocId,Probability,Target,name,profession,#3"

        assert_equal <<~EOF, File.read("eval.tsv")
          DocId\tProbability\tTarget\tname\tprofession\t#3
          0\t0.5755451606\t0\tAlex\tdoctor\tsenior
          1\t0.5819929128\t1\tDemid\tdentist\tjunior
          2\t0.6399684939\t1\tValentin\tprogrammer\tsenior
          3\t0.6479485073\t1\tIvan\tdoctor\tmiddle
          4\t0.5757021776\t0\tIvan\tdentist\tsenior
          5\t0.5543948515\t0\tValentin\tdentist\tmiddle
          6\t0.6022880215\t0\tMilan\tlawyer\tmiddle
          7\t0.5760162599\t0\tMilan\tprogrammer\tsenior
          8\t0.6423663059\t1\tValentin\tlawyer\tsenior
          9\t0.656955474\t1\tDemid\tdoctor\tmiddle
          10\t0.5992072123\t0\tValentin\tdentist\tmiddle
          11\t0.5782185863\t0\tMilan\tprogrammer\tsenior
          12\t0.6055756528\t1\tValentin\tdentist\tjunior
          13\t0.5209084714\t0\tIvan\tdoctor\tsenior
          14\t0.5840158456\t0\tValentin\tdentist\tsenior
          15\t0.60573894\t0\tMilan\tdentist\tsenior
          16\t0.5926617612\t0\tDemid\tlawyer\tmiddle
          17\t0.6298311784\t0\tValentin\tprogrammer\tsenior
          18\t0.6230447361\t1\tMilan\tlawyer\tsenior
          19\t0.6311443544\t1\tValentin\tlawyer\tjunior
        EOF
      end
    end
  end
end

__END__
diff --git a/conanfile.py b/conanfile.py
index 72453fe00a..8f4479b721 100644
--- a/conanfile.py
+++ b/conanfile.py
@@ -13,9 +13,6 @@ class App(ConanFile):

     default_options = {}

-    def requirements(self):
-        self.requires("openssl/3.0.15")
-
     def build_requirements(self):
         self.tool_requires("ragel/6.10")
         self.tool_requires("swig/4.0.2")
