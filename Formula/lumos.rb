class Lumos < Formula
  desc "Lumos CLI - Command line interface for Lumos platform"
  homepage "https://github.com/teamlumos/lumos-cli"
  version "2.3.0"
  license "MIT"

  on_macos do
    url "https://github.com/teamlumos/lumos-cli/releases/download/v2.3.0/lumos-macos-arm64-v2.3.0.tar.gz"
    sha256 "9363d8fde4c1671f33dbb6a83b802fd0eaf7b2dec524a495190e7feebf81e457"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.3.0/lumos-linux-amd64-v2.3.0.tar.gz"
      sha256 "90794aa3f2ecf4c65f6fa9850992957ebc4397eb121b9b19b434dd6adef81671"
    elsif Hardware::CPU.arm?
      url "https://github.com/teamlumos/lumos-cli/releases/download/v2.3.0/lumos-linux-arm64-v2.3.0.tar.gz"
      sha256 "34ada7ddfecbf538cd98a7c54497ec36398a797aaf32630a8f58d80c6720a165"
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
