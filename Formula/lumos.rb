class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.6.0/lumos"
    sha256 "235fa1519dd1e2fd9f6981710cdf50b4d9cba69bd4630bb492bf6ffba507a014"
    version "0.6.0"

    def install
        bin.install "lumos"
    end
end
