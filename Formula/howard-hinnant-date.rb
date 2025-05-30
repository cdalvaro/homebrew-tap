class HowardHinnantDate < Formula
  desc     "Date and time library based on the C++11/14/17 <chrono> header"
  homepage "https://github.com/HowardHinnant/date"
  url      "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.4.tar.gz"
  sha256   "56e05531ee8994124eeb498d0e6a5e1c3b9d4fccbecdf555fe266631368fb55f"
  license  "MIT"
  head     "https://github.com/HowardHinnant/date.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any,                 arm64_sequoia: "e1a1d22fe74b8b7897bff65da454f1031c5bdabd30de9058d750b26f0e8de829"
    sha256 cellar: :any,                 arm64_sonoma:  "98d8bc88897bd7e62f6eb426306de1373b001a28b16a899e2b7bac334fa32179"
    sha256 cellar: :any,                 ventura:       "fec6c509c1b6e79cecf1a50b196fdd687d0ae67f4de7e906d4e53bd0caa916ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023db19522fd883a442ab3cc4b33a12bbb4b968fc5692cab5f4991a08f972256"
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
