class BtSwitchChannel < Formula
  desc "Switch paired-host channels on Keychron and Logitech wireless devices"
  homepage "https://github.com/olegtarasov/bt-switch-channel"
  url "https://github.com/olegtarasov/bt-switch-channel/releases/download/v0.1.2/bt-switch-channel-0.1.2-macos-arm64.tar.gz"
  version "0.1.2"
  sha256 "fb0fb2afe8a9e8ee99c732fee58e1ccc8e6ab43440afd0da90be18eb07ba1451"
  license "MIT"

  depends_on arch: :arm64
  depends_on "hidapi"
  depends_on :macos

  on_macos do
    depends_on macos: :ventura
  end

  def install
    bin.install "bt-switch-channel"
  end

  test do
    assert_equal "bt-switch-channel #{version}\n",
      shell_output("#{bin}/bt-switch-channel --version")

    config = testpath/"config.json"
    system bin/"bt-switch-channel", "init", "--config", config
    assert_path_exists config

    output = shell_output("#{bin}/bt-switch-channel list --config #{config}")
    assert_match(/^keyboard:/, output)
    assert_match(/^mouse:/, output)
  end
end
