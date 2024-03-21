class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.5.1/lumos.tar.gz"
    sha256 "fe00eaa9e0f48fa229879b5b8bcec88c6ae32b9f9107f79ce224f9cb7211cf0d"
    version "0.5.1"

    def install
        bin.install "lumos"
    end
end
