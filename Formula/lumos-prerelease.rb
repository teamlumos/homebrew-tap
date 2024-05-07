class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.1.0-prerelease/lumos.tar.gz"
    sha256 "e41149bacb16807fae9f75fdcc92b5f132736785bb312740035017581a848285"
    version "1.1.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
