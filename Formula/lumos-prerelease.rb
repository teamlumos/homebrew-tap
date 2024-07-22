class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/2.1.0-prerelease/lumos.tar.gz"
    sha256 "06d67a5f7f53f331e44ce216f2b1955d7ce1cba109bd22931971e633a23bc77d"
    version "2.1.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
