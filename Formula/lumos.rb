class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.5.1/lumos"
    sha256 "95c676e838f91c534824ae957f00bcc89de733a375c48ca9473260c69bfa2962"
    version "0.5.1"

    def install
        bin.install "lumos"
    end
end
