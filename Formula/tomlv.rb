# typed: strict
# frozen_string_literal: true

# Formula for tomlv - TOML validator and formatter
class Tomlv < Formula
  desc "TOML validator and formatter"
  homepage "https://github.com/BurntSushi/toml"
  url "https://github.com/BurntSushi/toml/archive/refs/tags/v1.5.0.tar.gz"
  sha256 ""
  license "MIT"

  depends_on "go" => :build

  def install
    cd "cmd/tomlv" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    # Test that the binary runs and shows help
    assert_match "Usage", shell_output("#{bin}/tomlv --help")
  end
end
