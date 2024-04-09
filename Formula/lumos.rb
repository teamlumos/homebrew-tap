class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.4/lumos.tar.gz"
    sha256 "2b1296c7a1cb40676c7906a38d1f6b7fe435b5ffdbb1df1abde1ef3051930589"
    version "0.9.4"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
