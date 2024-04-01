class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.8.2/lumos.tar.gz"
    sha256 "a7b7deeb6dcd5f26bea8e39385b63641daa5c179c230b4784f146e6c1acc339e"
    version "0.8.2"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
