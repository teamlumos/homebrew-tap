class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/2.1.1-prerelease/lumos.tar.gz"
    sha256 "34f14409a50e137394b8114e13b8200a6fc668a36aabed0584e19a8ab976e4ee"
    version "2.1.1"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
