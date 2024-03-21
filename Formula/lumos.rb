class Lumos < Formula

    desc "Lumos CLI"
    homepage "https://app.lumosidentity.com"
    url "https://github.com/teamlumos/lumos-cli-releases/releases/download/0.5.1/lumos.tar.gz"
    sha256 "8c903d6481d103f0d8ce9071b1c35a861de8a9a059cf87dbb6de70ed9d07c9cf"  # Replace with the SHA256 checksum of the binary
    version "0.5.1"

    def install
        bin.install "lumos"
    end

    test do
    # Add test code here if needed
    end
end
