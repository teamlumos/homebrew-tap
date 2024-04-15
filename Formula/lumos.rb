class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.0.1/lumos.tar.gz"
    sha256 "d9bcf1a4495dbb070332518decbea70dbdbe5032d2f3a3b6d28add4e83f90150"
    version "1.0.1"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
