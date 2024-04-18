class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.0.4/lumos.tar.gz"
    sha256 "d63623373c5377217566448499e98c5755f08afb1139d1696b2b937fe3ecaaf1"
    version "1.0.4"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
