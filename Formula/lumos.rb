class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/2.0.0/lumos.tar.gz"
    sha256 "9c695b4d95421cdb53aadea28cee060887c1b7eeeda67693ba4a511757a1fc03"
    version "2.0.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
