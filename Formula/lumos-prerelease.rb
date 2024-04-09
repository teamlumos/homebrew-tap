class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.3-prerelease/lumos.tar.gz"
    sha256 "4fc9efe8fd73b9f6d7f506f2387302507205fce31fdc86d970b8cc25aebaff38"
    version "0.9.3"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
