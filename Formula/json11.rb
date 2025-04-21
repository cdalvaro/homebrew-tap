class Json11 < Formula
  desc     "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url      "https://github.com/dropbox/json11/archive/refs/tags/v1.0.0.tar.gz"
  sha256   "bab960eebc084d26aaf117b8b8809aecec1e86e371a173655b7dffb49383b0bf"
  license  "MIT"
  revision 1

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/json11-1.0.0"
    sha256 cellar: :any_skip_relocation, ventura:  "61f7ea75954629e7d4222219e394131dd62c0029b908615e10c6a9a6fc43b6de"
    sha256 cellar: :any_skip_relocation, monterey: "1fd312bbef10d5406bfd13ed8fe8512f7484ea082c6607b527f8ae0a5d4a030d"
    sha256 cellar: :any_skip_relocation, big_sur:  "bd3d883df2f5fe8f656acf1056ba6e79760ed444a3eb118b17fa3ae7eb267c3b"
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
