class Lumos < Formula
  desc "Lumos CLI - Command line interface for Lumos platform"
  homepage "https://github.com/teamlumos/lumos-cli"
  version "2.4.2"
  license "MIT"

  on_macos do
    url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.2/lumos-macos-arm64-v2.4.2.tar.gz"
    sha256 "4b48887cdfc334c58d12a6daf46c0eda741aa7548ae0a9a7c7bd45b437b0ec7e"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.2/lumos-linux-amd64-v2.4.2.tar.gz"
      sha256 "e0b0729312009666855c1a49349efb7e06ea92246e415c4d062c33e5a652e0bc"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.2/lumos-linux-arm64-v2.4.2.tar.gz"
      sha256 "70f584055ecdb4e911825130ef5f872c9b88c98fccca9297db432d6f74f6d89a"
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
