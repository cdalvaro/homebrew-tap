class Json11 < Formula
  desc     "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url      "https://github.com/dropbox/json11/archive/refs/tags/v1.0.0.tar.gz"
  sha256   "bab960eebc084d26aaf117b8b8809aecec1e86e371a173655b7dffb49383b0bf"
  license  "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc26511768d3dfe2f04da9703a667aafa463b62feb29d71e4a9da001f93b828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c87a35e433d49de42b0448f8e8a2749e120cbe7999279d8e7e4b49325c09cc"
    sha256 cellar: :any_skip_relocation, ventura:       "468d1fb72c0c17f2fdef8d177eeabb1a853eef6754f1d5b9a8c68a4a04b97a4b"
  end

  depends_on "cmake" => :build

  def install
    custom_cmake_args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", ".", *std_cmake_args, *custom_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json11.hpp>
      #include <string>
      using namespace json11;

      int main() {
        Json my_json = Json::object {
          { "key1", "value1" },
          { "key2", false },
          { "key3", Json::array { 1, 2, 3 } },
        };
        auto json_str = my_json.dump();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-ljson11", "-o", "test"
    system "./test"
  end
end
