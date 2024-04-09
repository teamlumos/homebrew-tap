class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.1-prerelease/lumos.tar.gz"
    sha256 "f2b9e19e2cf1eb2a99d56246f4a38dc1a5fa21622fccee45a410b5425c4a37a4"
    version "0.9.1"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
