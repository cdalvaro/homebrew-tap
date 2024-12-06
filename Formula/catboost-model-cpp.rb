require "yaml"

module ::Utils
  def self.add_clang_version_to_conan_settings(version)
    system "conan", "config", "init"
    conan_home = safe_popen_read("conan", "config", "home").strip
    settings_file = "#{conan_home}/settings.yml"
    settings = YAML.load_file(settings_file, aliases: true)
    clang_versions = settings["compiler"]["clang"]["version"]
    unless clang_versions.include?(version)
      clang_versions << version
      File.write(settings_file, YAML.dump(settings))
    end
  end
end

class CatboostModelCpp < Formula
  desc "Gradient Boosting on Decision Trees C++ Model Library"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost.git",
    tag:      "v1.2.7",
    revision: "f903943a8cd903a117c3d3c8421cc72d3910562c"
  license "Apache-2.0"
  head "https://github.com/catboost/catboost.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "conan@1" => :build
  depends_on "ninja" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "lld"
  end

  resource "model.cbm" do
    url "https://github.com/catboost/catboost/raw/refs/tags/v1.2.7/catboost/jvm-packages/catboost4j-prediction/src/test/resources/models/model.cbm"
    sha256 "9b07d25cf49f0e30ebcc05b7545af5fe029fb3f432a4f101949e4e48a357e164"
  end

  def install
    Utils.add_clang_version_to_conan_settings(Formula["llvm"].version.major.to_s) if ENV.key?("GITHUB_ACTIONS")

    args = [
      "-DCATBOOST_COMPONENTS=libs",
      "-DHAVE_CUDA=NO",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=On",
      "-DCMAKE_TOOLCHAIN_FILE=#{buildpath}/build/toolchains/clang.toolchain",
    ]

    cmakepath = buildpath/"cmake-build"
    system "cmake", "-S", ".", "-B", cmakepath, "-G", "Ninja", *args, *std_cmake_args
    system "ninja", "-C", cmakepath, "catboostmodel"

    lib.install cmakepath/"catboost/libs/model_interface/libcatboostmodel.#{OS.mac? ? "dylib" : "so"}"
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
  end
end
