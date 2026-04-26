class YabaiNg < Formula
  desc "Personal fork of yabai with managed spaces"
  homepage "https://github.com/olegtarasov/yabai-ng"
  url "https://github.com/olegtarasov/yabai-ng/releases/download/v26.0.0/yabai-ng-v26.0.0.tar.gz"
  sha256 "0befc7f5ca8d2a34f5a71b598b3526a5f61eba0ae98286da465fc945f25c302e"
  head "https://github.com/olegtarasov/yabai-ng.git", branch: "master"

  depends_on :macos => :big_sur

  def install
    if build.head?
      system "make", "-j1", "install"
      system "codesign", "-fs", "-", "#{buildpath}/bin/yabai"
      bin.install "#{buildpath}/bin/yabai"
      (pkgshare/"examples").install "#{buildpath}/examples/yabairc"
      (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
      man1.install "#{buildpath}/doc/yabai.1"
    else
      bin.install "bin/yabai"
      (pkgshare/"examples").install "examples/yabairc"
      (pkgshare/"examples").install "examples/skhdrc"
      man1.install "doc/yabai.1"
    end
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/yabairc ~/.yabairc
      cp #{opt_pkgshare}/examples/skhdrc ~/.skhdrc

    If you want yabai to be managed by launchd (start automatically upon login):
      yabai --start-service

    When running as a launchd service logs will be found in:
      /tmp/yabai_<user>.[out|err].log

    If you are using the scripting-addition; remember to update your sudoers file:
      sudo visudo -f /private/etc/sudoers.d/yabai

    Build the configuration row by running:
      echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(\which yabai) | cut -d " " -f 1) $(\which yabai) --load-sa"

    README: https://github.com/olegtarasov/yabai-ng#installation-and-configuration
    EOS
  end

  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
  end
end
