class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.0.0-prerelease/lumos.tar.gz"
    sha256 "eff744a67515a67573c759b50d65744de5fa3be622d16f6cc9a2e9687693b2d6"
    version "1.0.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
