class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/1.1.2/lumos.tar.gz"
    sha256 "4f96b68689409ec6efec7271c56abcca96da30134097080ca7b115636600804f"
    version "1.1.2"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
