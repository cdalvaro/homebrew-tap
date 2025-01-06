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
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any,                 arm64_sequoia: "db7a350903e04979bc5e16cfc286049f8478662c67064eb19238a8f849f89f83"
    sha256 cellar: :any,                 arm64_sonoma:  "c2a4d2c38934798d125f0a2fcf47df74be1c8dd8037612487bf930b9e431b0aa"
    sha256 cellar: :any,                 ventura:       "fc62956f862c168e715c5670bdb9f3324e04b93d5dd863f172ce35c586654cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed0bbeec12474d44f1db45502d677908ebe6f3d97ac98a5b3df185da73fdd02"
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
