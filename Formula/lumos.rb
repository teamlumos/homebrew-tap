class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.7/lumos.tar.gz"
    sha256 "15594347910ea6dab18e4ff6c368d0c70d15569db7055fd119b741953134c844"
    version "0.9.7"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
