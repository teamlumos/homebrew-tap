class LumosPrerelease < Formula
  desc "Lumos CLI - Command line interface for Lumos platform"
  homepage "https://github.com/teamlumos/lumos-cli"
  version "2.3.0"
  license "MIT"

  on_macos do
    url "https://github.com/teamlumos/lumos-cli/releases/download/2.1.2-prerelease/lumos-macos-arm64.tar.gz"
    sha256 "415a9c5ecca9d43642d1d5f82be0f3ed98c3f42a175a569988e2124ba521ebb7"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/2.1.2-prerelease/lumos-linux-amd64.tar.gz"
      sha256 "x"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/2.1.2-prerelease/lumos-linux-arm64.tar.gz"
      sha256 "x"
    end
  end

  def install
    bin.install "lumos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lumos --version")
  end
end
