class Json11 < Formula
  desc     "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url      "https://github.com/dropbox/json11/archive/refs/tags/v1.0.0.tar.gz"
  sha256   "bab960eebc084d26aaf117b8b8809aecec1e86e371a173655b7dffb49383b0bf"
  license  "MIT"
  revision 3

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/json11-1.0.0_3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63e4809f77d1bc0058f8325f2c2850d905616a5436ee08ae294664b302bebe7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db5d60289cde2c6645a247a557ddb4cbc338998513b6baac63c8e8eaac6269ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95c14534cdfb25fe354d13ea508951d8ed6dfe83077f2e30f8057cba2e13bdff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6bb9d63b21d1aaaa7251642f6c4f3f761243af0e42ecea0150a5c38a72e9ba72"
  end

  depends_on "cmake" => :build

  def install
    # Upstream installs headers/libs under an arch-specific subdirectory
    # (e.g. `include/x86_64-linux-gnu`) on multiarch Linux, breaking `-I#{include}`.
    inreplace "CMakeLists.txt", "/${CMAKE_LIBRARY_ARCHITECTURE}", ""

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args, "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
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
