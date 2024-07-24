class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/2.1.2/lumos.tar.gz"
    sha256 "518c78d52e30408845ecc1709a67912edbd221a12bad1859774b43dbba3106dd"
    version "2.1.2"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
