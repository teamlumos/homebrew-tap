class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/2.1.2-prerelease/lumos.tar.gz"
    sha256 "415a9c5ecca9d43642d1d5f82be0f3ed98c3f42a175a569988e2124ba521ebb7"
    version "2.1.2"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
