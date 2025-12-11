class Lumos < Formula
  desc "Lumos CLI - Command line interface for Lumos platform"
  homepage "https://github.com/teamlumos/lumos-cli"
  version "2.3.0"
  license "MIT"

  on_macos do
    url "https://github.com/teamlumos/lumos-cli/releases/download/v2.3.0/lumos-macos-arm64-v2.3.0.tar.gz"
    sha256 "2ea0beeb41e2bd449abda1698663e5c20fbecac505734ee701345c4f2b1221d2"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.3.0/lumos-linux-amd64-v2.3.0.tar.gz"
      sha256 "e0a1fb4ce311844b0b874eb22a354a00a8ce2a477fac758aa687eb0f7e87cc52"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.3.0/lumos-linux-arm64-v2.3.0.tar.gz"
      sha256 "3aebe52f1fa00ca25cab520524bea0e472d60dc3936caa2b379ed57c7fea74b2"
    end
  end

  def install
    bin.install "lumos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lumos --version")
  end
end
