class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.0.0/lumos.tar.gz"
    sha256 "c773034886b4690b71ec934e9e6f68109d68f5c51a7399472b325306fc8c081b"
    version "1.0.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
