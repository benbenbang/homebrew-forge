class Tomlv < Formula
  desc "TOML validator - command-line tool to validate TOML files"
  homepage "https://github.com/BurntSushi/toml"
  url "https://github.com/BurntSushi/toml/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "723ede1a61ca8311046f840020e485dec3ceb2e614d1a539cd154375bdd7b8cb"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tomlv"
  end

  test do
    (testpath/"test.toml").write <<~EOS
      [section]
      key = "value"
      number = 42
    EOS

    assert_match "valid TOML", shell_output("#{bin}/tomlv test.toml 2>&1")

    (testpath/"invalid.toml").write <<~EOS
      [section
      key = "value"
    EOS

    assert_match "error", shell_output("#{bin}/tomlv invalid.toml 2>&1", 1)
  end
end
