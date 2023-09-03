class CatboostCli < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees cli tool"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost.git",
      tag:      "v1.2.1",
      revision: "d03b246cae23490dcf991cf822be110d6f818665"
  license "Apache-2.0"
  revision 3
  head "https://github.com/catboost/catboost.git", branch: "master"

  bottle do
    root_url "https://github.com/cdalvaro/homebrew-tap/releases/download/catboost-cli-1.2.1_3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24b0ee0a2c87474d58fe50612919c30320d290bc516d283998ac871d3d9f8aaf"
    sha256 cellar: :any_skip_relocation, ventura:       "cf5652a796ce4a662a7ce90c5e7264890e8509202d6f784386f8136729197556"
    sha256 cellar: :any_skip_relocation, monterey:      "445e8c633a6ac6e5da3356fd3e01e54211cb9d72ce52d49e6c3f257fa2f29db3"
    sha256 cellar: :any_skip_relocation, big_sur:       "75cb0eeed6f94f74c98c8b5cbe3d9b0fba4c5613878626fe9ac07587f24ad775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93bc65e5c57b7b08acbf65ffdecc91f50d229a420c189c834f3ddd37a8743f67"
  end

  depends_on "cmake" => :build
  depends_on "conan@1" => :build
  depends_on "ninja" => :build

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
    system "cmake", "-S", ".", "-B", cmakepath, "-G", "Ninja", *args, *std_cmake_args
    system "ninja", "-C", cmakepath, "catboost"
    bin.install cmakepath/"catboost/app/catboost"
  end

  test do
    assert_match %r{Branch: tags/v#{version}}, shell_output("#{bin}/catboost --version")

    resource("testdata").stage do
      cd "cmdline_tutorial" do
        system bin/"catboost", "fit", "--learn-set", "train.tsv", "--test-set", "test.tsv", "--column-description",
"train.cd", "--loss-function", "RMSE", "--iterations", "1000", "--seed", 1, "--verbose", "0"
        system bin/"catboost", "calc", "-m", "model.bin", "--input-path", "test.tsv", "--cd", "train.cd", "-o",
"eval.tsv", "-T", "1", "--output-columns", "DocId,Probability,Target,name,profession,#3"

        assert_equal <<~EOF, File.read("eval.tsv")
          DocId\tProbability\tTarget\tname\tprofession\t#3
          0\t0.5755451606\t0\tAlex\tdoctor\tsenior
          1\t0.5819929128\t1\tDemid\tdentist\tjunior
          2\t0.6399684939\t1\tValentin\tprogrammer\tsenior
          3\t0.6479485073\t1\tIvan\tdoctor\tmiddle
          4\t0.5757021776\t0\tIvan\tdentist\tsenior
          5\t0.5543948515\t0\tValentin\tdentist\tmiddle
          6\t0.6022880215\t0\tMilan\tlawyer\tmiddle
          7\t0.5760162599\t0\tMilan\tprogrammer\tsenior
          8\t0.6423663059\t1\tValentin\tlawyer\tsenior
          9\t0.656955474\t1\tDemid\tdoctor\tmiddle
          10\t0.5992072123\t0\tValentin\tdentist\tmiddle
          11\t0.5782185863\t0\tMilan\tprogrammer\tsenior
          12\t0.6055756528\t1\tValentin\tdentist\tjunior
          13\t0.5209084714\t0\tIvan\tdoctor\tsenior
          14\t0.5840158456\t0\tValentin\tdentist\tsenior
          15\t0.60573894\t0\tMilan\tdentist\tsenior
          16\t0.5926617612\t0\tDemid\tlawyer\tmiddle
          17\t0.6298311784\t0\tValentin\tprogrammer\tsenior
          18\t0.6230447361\t1\tMilan\tlawyer\tsenior
          19\t0.6311443544\t1\tValentin\tlawyer\tjunior
        EOF
      end
    end
  end
end
