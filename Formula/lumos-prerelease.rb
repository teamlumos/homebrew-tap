class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.1.1-prerelease/lumos.tar.gz"
    sha256 "a7fb66ae969a69f8570742d8bb3b8485ce3a195d1abddc9d72433c5311cd4524"
    version "1.1.1"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
