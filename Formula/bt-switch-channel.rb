class BtSwitchChannel < Formula
  desc "Switch paired-host channels on Keychron and Logitech wireless devices"
  homepage "https://github.com/olegtarasov/bt-switch-channel"
  url "https://github.com/olegtarasov/bt-switch-channel/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6a7da5b031635b6f5aa4c738bb8dd91c97e5e96ac64dccfbfe950a82755930b5"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on xcode: ["16.0", :build]
  depends_on "hidapi"
  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/bt-switch-channel"
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
