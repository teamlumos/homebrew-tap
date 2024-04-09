class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.6/lumos.tar.gz"
    sha256 "0a4cf0af90f47234166a3c041f20b402e71807d3aff97c80dc8338d46619e471"
    version "0.9.6"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
