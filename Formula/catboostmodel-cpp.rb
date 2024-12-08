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

class CatboostmodelCpp < Formula
  desc "Gradient Boosting on Decision Trees C++ Model Library"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost.git",
    tag:      "v1.2.7",
    revision: "f903943a8cd903a117c3d3c8421cc72d3910562c"
  license "Apache-2.0"
  head "https://github.com/catboost/catboost.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ed3909be24e666126832528aba31af7967fd3941bcd5b9db60005107555db506"
    sha256 cellar: :any,                 arm64_sonoma:  "cd2a4bd5054718ef241fd4617a47de4e510c024b94287360c2b1992c193494c5"
    sha256 cellar: :any,                 ventura:       "821a5f2ba3f222aab960f1bbf417b8acb9cfe9dd245a27865553957d6feff7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0972cfed70646d666126ff5473a68da6a4202cb1294cbac765fad5756f5c5bd9"
  end

  option "with-static", "Also install the static library"

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
      "-DHAVE_CUDA=no",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=On",
      "-DCMAKE_TOOLCHAIN_FILE=#{buildpath}/build/toolchains/clang.toolchain",
    ]

    targets = ["catboostmodel"]
    targets << "catboostmodel_static" if build.with?("static")

    cmakepath = buildpath/"cmake-build"
    system "cmake", "-S", ".", "-B", cmakepath, "-G", "Ninja", *args, *std_cmake_args
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
