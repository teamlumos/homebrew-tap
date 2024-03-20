class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://example.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.4.0/lumos"
    sha256 "00000000000000000000"  # Replace with the SHA256 checksum of the binary

    def install
        puts("hello from lumos install")
        bin.install "lumos"
    end

    test do
    # Add test code here if needed
    end
end