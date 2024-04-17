class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.0.2/lumos.tar.gz"
    sha256 "d2147337257089ee51ad6af8abc5012b13d8c60fc5afc7add340357638705ac0"
    version "1.0.2"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
