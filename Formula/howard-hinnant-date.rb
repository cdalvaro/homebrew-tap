class HowardHinnantDate < Formula
  desc     "Date and time library based on the C++11/14/17 <chrono> header"
  homepage "https://github.com/HowardHinnant/date"
  url      "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.5.tar.gz"
  sha256   "ef786edc203daec76475825640b3af247bd08e31fc52217e5ce8f76107b4bb05"
  license  "MIT"
  head     "https://github.com/HowardHinnant/date.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/howard-hinnant-date-3.0.5"
    sha256 cellar: :any, arm64_golden_gate: "85cba9ca6c8f0ddd3e26cef2728e1be408d8cb345fc39af630ebb604f9fdadad"
    sha256 cellar: :any, arm64_tahoe:       "08c95e99199546ba92d383748ed86b8c751ccce108b5ad324d7354d3b038d3cf"
    sha256 cellar: :any, arm64_sequoia:     "8e0aa474690e09642b02ece37406212d5061f1a501bf4b9f2da03a33cba960c6"
    sha256 cellar: :any, x86_64_linux:      "bb7bd22869678482fad61c17d7d8662f5216f05e2e39b1f189441b24861ee205"
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

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args, *custom_args
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
