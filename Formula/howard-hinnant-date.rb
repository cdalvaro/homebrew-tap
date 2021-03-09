class HowardHinnantDate < Formula
  desc     "Date and time library based on the C++11/14/17 <chrono> header"
  homepage "https://github.com/HowardHinnant/date"
  url      "https://github.com/HowardHinnant/date/archive/v3.0.0.tar.gz"
  sha256   "87bba2eaf0ebc7ec539e5e62fc317cb80671a337c1fb1b84cb9e4d42c6dbebe3"
  license  "MIT"
  head     "https://github.com/HowardHinnant/date.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/howard-hinnant-date-3.0.0"
    sha256 cellar: :any_skip_relocation, catalina: "8eea94bb442f0589b21b8f0fb361d29e8d1213169c93cf45f65ad2dad6cb8dc1"
  end

  option "without-string-view", "Disable C++ string view"

  depends_on "cmake" => :build

  def install
    custom_args = [
      "-DENABLE_DATE_TESTING=OFF",
      "-DUSE_SYSTEM_TZ_DB=ON",
      "-DBUILD_SHARED_LIBS=ON",
      "-DBUILD_TZ_LIB=ON",
    ]

    disable_string_view = build.with?("string-view") ? "OFF" : "ON"
    custom_args << "-DDISABLE_STRING_VIEW=#{disable_string_view}"

    system "cmake", ".", *std_cmake_args, *custom_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "date/tz.h"
      #include <iostream>
      int main() {
        auto t = date::make_zoned(date::current_zone(), std::chrono::system_clock::now());
        std::cout << t << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-L#{lib}", "-ldate-tz", "-o", "test"
    system "./test"
  end
end
