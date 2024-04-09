class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.0/lumos.tar.gz"
    sha256 "dd019c37816119e941a0a4af924baa4a3a58845955f3f423f4adbb56a9871234"
    version "0.9.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
