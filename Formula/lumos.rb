class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.0.3/lumos.tar.gz"
    sha256 "0d6036ff0e1cef370b07285266490a32bef36d7b4a869688e1d6a81af206a3fb"
    version "1.0.3"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
