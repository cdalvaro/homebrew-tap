class CatboostmodelCpp < Formula
  desc "Gradient Boosting on Decision Trees C++ Model Library"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost.git",
    tag:      "v1.2.9",
    revision: "e7d262e7b58fc3217dd8ccbf7c246189873814e6"
  license "Apache-2.0"
  head "https://github.com/catboost/catboost.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any,                 arm64_sequoia: "85c1dc6a11fdbec97907f2793b00e6b737961dcf9a8fa1995d4a3b51807d5224"
    sha256 cellar: :any,                 arm64_sonoma:  "e64142489bfb1685fce900144d3fcc62f2f76e1f5eab06a27c4203cd06961f33"
    sha256 cellar: :any,                 ventura:       "3434a27aa3f28cc7fa1e5ee31f448056e8fa745fbdeabeb4bec7315f077b5343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ac8b833889bc989817f3fcc90684672190364c1b01a488cb53c9f354647f65"
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
