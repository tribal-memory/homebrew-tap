class Tribal < Formula
  desc "Capture tribal knowledge. Give it to your agents."
  homepage "https://github.com/samfolo/tribal"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/samfolo/tribal/releases/download/v0.1.1/tribal-aarch64-apple-darwin.tar.xz"
      sha256 "e30538c7a52bf28d52c987df99d570a682b363b90456d2c48ebce1cd39bac03a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/samfolo/tribal/releases/download/v0.1.1/tribal-x86_64-apple-darwin.tar.xz"
      sha256 "5732e3a9f6bb24b65957ef38f655a0dcf2ddd44d36ff21157ebf2725d99c76f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/samfolo/tribal/releases/download/v0.1.1/tribal-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc57a3516a486c0c454c87d3c74232182c2036f18f8d24f8dba94f6160c204db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/samfolo/tribal/releases/download/v0.1.1/tribal-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5221cfc8e17290a57c3064d577d1376c07a1daafe161453a8a7474875f6a5dc3"
    end
  end
  license "Elastic-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tribal" if OS.mac? && Hardware::CPU.arm?
    bin.install "tribal" if OS.mac? && Hardware::CPU.intel?
    bin.install "tribal" if OS.linux? && Hardware::CPU.arm?
    bin.install "tribal" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
