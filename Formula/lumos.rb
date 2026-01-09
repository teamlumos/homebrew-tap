class Lumos < Formula
  desc "Lumos CLI - Command line interface for Lumos platform"
  homepage "https://github.com/teamlumos/lumos-cli"
  version "2.4.0"
  license "MIT"

  on_macos do
    url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.0/lumos-macos-arm64-2.4.0.tar.gz"
    sha256 "70eaf0d264b78f261becc0df1eed4f73511d2563b207c57532b77869237e3a72"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.0/lumos-linux-amd64-2.4.0.tar.gz"
      sha256 "304a1a3ea8228afe12a693c3d89a51158d5eef692a611b5761ee52a0eed561d8"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.0/lumos-linux-arm64-2.4.0.tar.gz"
      sha256 "62d747fd11ac8fa7fdb73bfe67b17d01c511a8dd3507bcffd6deca2fed0fe6fa"
    end
  end

  def install
    libexec.install "lumos", "_internal"
    bin.write_exec_script libexec/"lumos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lumos --version")
  end
end
