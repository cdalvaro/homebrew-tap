class CppPlotly < Formula
  desc     "Generate html/javascript charts from C++ using plotly.js library"
  homepage "https://github.com/pablrod/cppplotly"
  url      "https://github.com/pablrod/cppplotly/archive/refs/tags/v0.4.0.tar.gz"
  sha256   "378a978d5e6d06685e83593bbd5c4652685c2340240312ce57913befcca9f7c3"
  revision 3
  head     "https://github.com/pablrod/cppplotly.git", branch: "master"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/cpp-plotly-0.4.0_3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea8cbb7b20ee897ba6eddc1daea9ea67c342b2707756fd2410f2363fdc093965"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24377b720f9c7d328534ffc2777022dff25815934c2fdeaf289a5e603aa4b668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f68e8485f90b13a09d93af9c5f254ff99ce13ad22eb4118b1f3c742f22868c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bef98638ee7875483546e537c33692cb19797598b41f63e7b1126339a5dbf601"
  end

  depends_on "cdalvaro/tap/json11"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <vector>
      #include <memory>
      #include <sstream>
      #include "CppPlotly/Plot.h"
      #include "CppPlotly/Trace/Scatter.h"
      #include "CppPlotly/Trace/Bar.h"
      #include "CppPlotly/Trace/Scatter3d.h"
      int main(void) {
        auto scatter = CppPlotly::Trace::Scatter().X({1, 2, 3, 4, 5}).Y({2, 4, 8, 16, 32});
        auto scatter3d = CppPlotly::Trace::Scatter3d().X({1, 2, 3}).Y({1, 2, 3}).Z({1, 2, 3});
        auto another_scatter = CppPlotly::BaseTrace::Pointer(&((new CppPlotly::Trace::Bar())->
          Y({1, 2, 3, 4, 5}).X({"1", "2", "3", "4", "5"})));
        auto plot = CppPlotly::Plot().AddTrace(scatter).AddTrace(another_scatter);
        std::cout << plot.render_html() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-std=c++14",
          "test.cpp",
          "-L#{formula_opt_lib("json11")}", "-ljson11",
          "-o", "test"
    system "./test"
  end
end
