class Lumos < Formula
  desc "Lumos CLI - Command line interface for Lumos platform"
  homepage "https://github.com/teamlumos/lumos-cli"
  version "2.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/2.1.2/lumos-darwin-amd64.tar.gz"
      sha256 "518c78d52e30408845ecc1709a67912edbd221a12bad1859774b43dbba3106dd"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/2.1.2/lumos-darwin-arm64.tar.gz"
      sha256 "518c78d52e30408845ecc1709a67912edbd221a12bad1859774b43dbba3106dd"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/2.1.2/lumos-linux-amd64.tar.gz"
      sha256 "518c78d52e30408845ecc1709a67912edbd221a12bad1859774b43dbba3106dd"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/2.1.2/lumos-linux-arm64.tar.gz"
      sha256 "518c78d52e30408845ecc1709a67912edbd221a12bad1859774b43dbba3106dd"
    end
  end

  def install
    bin.install "lumos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lumos --version")
  end
end
