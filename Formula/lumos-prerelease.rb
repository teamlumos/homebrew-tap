class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.0/lumos.tar.gz"
    sha256 "5ac28b71c28608117ae0501ac7c365c2dbdd1a9a61f1094bcadad4509ae0d068"
    version "0.9.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
