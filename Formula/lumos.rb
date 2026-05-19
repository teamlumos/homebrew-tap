class Lumos < Formula
  desc "Lumos CLI - Command line interface for Lumos platform"
  homepage "https://github.com/teamlumos/lumos-cli"
  version "2.4.1"
  license "MIT"

  on_macos do
    url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.1/lumos-macos-arm64-v2.4.1.tar.gz"
    sha256 "3dc0261fbcdb8238945f75c30ef5f921490bb633502fd1f455860db01154f488"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.1/lumos-linux-amd64-v2.4.1.tar.gz"
      sha256 "feff8d7d4c1e4461c8a753958be1eaf344a33862c067eafed31af9cc3dc49148"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.4.1/lumos-linux-arm64-v2.4.1.tar.gz"
      sha256 "da8f526a5052231ed7a2058dcaa39eac23c48a8a11d85327c192657e95497bab"
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
