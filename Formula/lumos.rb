class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.7.1/lumos.tar.gz"
    sha256 "b3eaa450b04c7c10048f081dff947f7d17c2831d412cf520d2c346069ae15afe"
    version "0.7.1"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
