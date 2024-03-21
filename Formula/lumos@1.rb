class LumosAT1 < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/1.0.0/lumos.tar.gz"
    sha256 "b5e7724063a4af780aa2d642a79b975c2cd3ff42c6cd60cdf131ca9614dee72b"
    version "1.0.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
