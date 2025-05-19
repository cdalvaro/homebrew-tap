class CppPlotly < Formula
  desc     "Generate html/javascript charts from C++ using plotly.js library"
  homepage "https://github.com/pablrod/cppplotly"
  url      "https://github.com/pablrod/cppplotly/archive/refs/tags/v0.4.0.tar.gz"
  sha256   "378a978d5e6d06685e83593bbd5c4652685c2340240312ce57913befcca9f7c3"
  revision 2
  head     "https://github.com/pablrod/cppplotly.git"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://ghcr.io/v2/cdalvaro/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75434f6b07fbf7e97ce88fc11f82f1926301fea47d51dc9d44daa73a59e6404a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89104499fac3ffb9234aab9818e582917b458d4775732815c54b89c549c1cb3e"
    sha256 cellar: :any_skip_relocation, ventura:       "7166bf71dd0597915bc92014b2d880a86da6200b5e52f7e7f41c9e8f04c26aed"
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
           "-L#{Formula["json11"].opt_lib}", "-ljson11",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
