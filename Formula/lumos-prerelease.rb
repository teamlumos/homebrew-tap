class LumosPrerelease < Formula

    desc "Lumos CLI"
    homepage "https://github.com/teamlumos/homebrew-tap"
    url "https://github.com/teamlumos/homebrew-tap/releases/download/0.9.0/lumos.tar.gz"
    sha256 "5e7e3a147c3cbb9bc1beceac57adb2b10da104c04df0a59107d2d5e49bd06534"
    version "0.9.0"

    def install
        libexec.install Dir["*"]
        bin.write_exec_script libexec/"lumos"
    end
end
