class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.8.3/lumos.tar.gz"
    sha256 "cdad87edec7d6fcaf1f546f666a53bee164d31d2d0cb92c9bb9c2ffce2f06e8b"
    version "0.8.3"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
