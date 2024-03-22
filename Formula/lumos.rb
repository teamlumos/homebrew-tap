class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.7.1/lumos.tar.gz"
    sha256 "772e05e6b0a1680637bdc5513b15a067773997df4b4a06efeeb8111d8046ce23"
    version "0.7.1"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
