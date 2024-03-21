class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.7.0/lumos.tar.gz"
    sha256 "0bdd5e5e72c390413eabd4bd09cee124ebaa530f758887c1e65d6c01e3851a86"
    version "0.7.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
