class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost.git",
      tag:      "v1.2.1",
      revision: "d03b246cae23490dcf991cf822be110d6f818665"
  license "Apache-2.0"
  revision 1
  head "https://github.com/catboost/catboost.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "conan@1" => :build

  uses_from_macos "llvm" => :build

  resource "testdata" do
    url "https://github.com/catboost/tutorials.git",
        branch:   "master",
        revision: "b85bed6b57feafc84e3984872260f9888c9f3bae"
  end

  def install
    args = [
      "-DCATBOOST_COMPONENTS=app",
      "-DHAVE_CUDA=NO",
      "-DCMAKE_TOOLCHAIN_FILE=#{buildpath}/build/toolchains/clang.toolchain",
    ]

    cmakepath = buildpath/"cmake-build"
    system "cmake", "-S", ".", "-B", cmakepath, *args, *std_cmake_args

    cd cmakepath/"catboost/app" do
      system "cmake", "--build", "."
      bin.install "catboost"
    end
  end

  test do
    assert_match %r{Branch: tags/v#{version}}, shell_output("#{bin}/catboost --version")

    resource("testdata").stage do
      cd "cmdline_tutorial" do
        system bin/"catboost", "fit", "--learn-set", "train.tsv", "--test-set", "test.tsv", "--column-description",
"train.cd", "--model-file", "model.bin", "--loss-function", "Logloss", "--iterations", "1000", "--learning-rate",
"0.03", "--verbose", "False"
        system bin/"catboost", "calc", "-m", "model.bin", "--input-path", "test.tsv", "--cd", "train.cd", "-o",
"eval.tsv", "-T", "4", "--output-columns", "DocId,Probability,Target,name,profession,#3"

        assert_equal <<~EOF, File.read("eval.tsv")
          DocId\tProbability\tTarget\tname\tprofession\t#3
          0\t0.1256678602\t0\tAlex\tdoctor\tsenior
          1\t0.1471174882\t1\tDemid\tdentist\tjunior
          2\t0.4661616102\t1\tValentin\tprogrammer\tsenior
          3\t0.4910298378\t1\tIvan\tdoctor\tmiddle
          4\t0.0925052226\t0\tIvan\tdentist\tsenior
          5\t0.2364051333\t0\tValentin\tdentist\tmiddle
          6\t0.1996722417\t0\tMilan\tlawyer\tmiddle
          7\t0.142412171\t0\tMilan\tprogrammer\tsenior
          8\t0.3372873581\t1\tValentin\tlawyer\tsenior
          9\t0.4685118935\t1\tDemid\tdoctor\tmiddle
          10\t0.3564761617\t0\tValentin\tdentist\tmiddle
          11\t0.2139090838\t0\tMilan\tprogrammer\tsenior
          12\t0.1326824675\t1\tValentin\tdentist\tjunior
          13\t0.2208982759\t0\tIvan\tdoctor\tsenior
          14\t0.09890330302\t0\tValentin\tdentist\tsenior
          15\t0.2192490085\t0\tMilan\tdentist\tsenior
          16\t0.2296542341\t0\tDemid\tlawyer\tmiddle
          17\t0.5508066849\t0\tValentin\tprogrammer\tsenior
          18\t0.436208192\t1\tMilan\tlawyer\tsenior
          19\t0.3482629472\t1\tValentin\tlawyer\tjunior
        EOF
      end
    end
  end
end
