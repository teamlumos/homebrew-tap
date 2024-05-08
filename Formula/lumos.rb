class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.1.1/lumos.tar.gz"
    sha256 "11219115e1aa2aaf9a228168e2b5ec6c7fd6beb1231dd9d9e5ac23653b44b2df"
    version "1.1.1"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
