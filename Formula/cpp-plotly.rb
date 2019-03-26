class CppPlotly < Formula
  desc     "Generate html/javascript charts from C++ using plotly.js library"
  homepage "https://github.com/pablrod/cppplotly"
  url      "https://github.com/pablrod/cppplotly/archive/v0.4.0.tar.gz"
  sha256   "378a978d5e6d06685e83593bbd5c4652685c2340240312ce57913befcca9f7c3"
  head     "https://github.com/pablrod/cppplotly.git"
  bottle   :unneeded

  depends_on "json11"

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
           "-L#{Formula["json11"].opt_lib}", "-ljson11",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
