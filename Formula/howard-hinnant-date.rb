class HowardHinnantDate < Formula
  desc     "Date and time library based on the C++11/14/17 <chrono> header"
  homepage "https://github.com/HowardHinnant/date"
  url      "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.3.tar.gz"
  sha256   "30de45a34a2605cca33a993a9ea54e8f140f23b1caf1acf3c2fd436c42c7d942"
  license  "MIT"
  head     "https://github.com/HowardHinnant/date.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/howard-hinnant-date-3.0.1"
    sha256 cellar: :any, big_sur:  "ee1ed7ac1e314d6ac5bd2b6fd61dbc29bcdb9ab769e06496cae079ac22dbdf57"
    sha256 cellar: :any, catalina: "2e6f33083eed1c69a6bfe6b9f6c9b006b68755246e2e1d9a0e51f0ef446bd1b3"
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
