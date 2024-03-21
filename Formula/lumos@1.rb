class LumosAT1 < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.6.1/lumos.tar.gz"
    sha256 "8825014adde0bfd99c1df486bf4eca7f48ce3aa55562110b9da862943ae1b50a"
    version "0.6.1"

    def install
        bin.install "lumos"
    end
end
