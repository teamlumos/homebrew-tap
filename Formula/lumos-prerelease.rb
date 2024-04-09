class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.0-prerelease/lumos.tar.gz"
    sha256 "8114f9591519ad360993ad8ae4a15afeefe784e29c304c37f076612d784be8f3"
    version "0.9.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
