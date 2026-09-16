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

class CatboostmodelCpp < Formula
  desc "Gradient Boosting on Decision Trees C++ Model Library"
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
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboostmodel-cpp-1.2.10_1"
    sha256 cellar: :any, arm64_golden_gate: "d76772aef86a504ec73cc7faf2ea9ba2daf4912dce110b8883a34fa7e0c6e656"
    sha256 cellar: :any, arm64_tahoe:       "1ae951d327cd2a23c31cfad72ffa1791f14694274ffee1adad584395ffe4745d"
    sha256 cellar: :any, arm64_sequoia:     "9b4db871295fb9d07ead6313306c91c026b5de7dafc4acd0949335769e47f40b"
    sha256 cellar: :any, x86_64_linux:      "1d1151a74c8681b42ddaa33d7c1b6d2c034cc5123dcfbf06856cb199228d3f93"
  end

  option "with-static", "Also install the static library"

  depends_on "cmake" => :build
  depends_on "conan" => :build
  depends_on "ninja" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "openssl@3.0" => :build
    depends_on "lld"

    patch :DATA
  end

  resource "model.cbm" do
    url "https://github.com/catboost/catboost/raw/refs/tags/v1.2.8/catboost/jvm-packages/catboost4j-prediction/src/test/resources/models/model.cbm"
    sha256 "9b07d25cf49f0e30ebcc05b7545af5fe029fb3f432a4f101949e4e48a357e164"
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
      "-DCATBOOST_COMPONENTS=libs",
      "-DHAVE_CUDA=no",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=On",
      "-DCMAKE_TOOLCHAIN_FILE=#{buildpath}/build/toolchains/clang.toolchain",
      "-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=#{cmake_project_top_level_includes.join(";")}",
    ]

    targets = ["catboostmodel"]
    targets << "catboostmodel_static" if build.with?("static")

    cmakepath = buildpath/"cmake-build"
    system "cmake", "-S", ".", "-B", cmakepath, "-G", "Ninja", *std_cmake_args, *args
    system "ninja", "-C", cmakepath, *targets

    lib.install cmakepath/"catboost/libs/model_interface/libcatboostmodel.#{OS.mac? ? "dylib" : "so"}"
    lib.install Dir[cmakepath/"catboost/libs/model_interface/static/*.a"] if build.with?("static")

    %w[c_api.h wrapped_calcer.h].each do |header|
      (include/"catboost/model_interface").install Dir[buildpath/"catboost/libs/model_interface/#{header}"]
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <catboost/model_interface/wrapped_calcer.h>
      #include <iostream>

      int main(int argc, char** argv) {
          ModelCalcerWrapper calcer("model.cbm");
          std::vector<float> floatFeatures(100);
          std::vector<std::string> catFeatures = {"one", "two", "three"};
          std::cout << calcer.Calc(floatFeatures, catFeatures) << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, testpath/"test.cpp", "-std=c++1y", "-L#{lib}", "-lcatboostmodel", "-o", testpath/"test"
    resource("model.cbm").stage { system testpath/"test" }

    if build.with?("static")
      libs = [
        lib/"libcatboostmodel_static.global.a",
        lib/"libcatboostmodel_static.a",
      ]

      libs += %w[-lpthread -ldl] if OS.linux?

      system ENV.cxx, testpath/"test.cpp", "-std=c++1y", *libs, "-o", testpath/"test_static"
      resource("model.cbm").stage { system testpath/"test_static" }
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
