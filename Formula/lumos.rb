class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.7.0/lumos.tar.gz"
    sha256 "8e5095020d83e1b016aa4b2b149793c0c4067bda27bf6ce9e704b57c32f79797"
    version "0.7.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
