class Tribal < Formula
  desc "Capture tribal knowledge. Give it to your agents."
  homepage "https://github.com/tribal-memory/tribal"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.3.0/tribal-aarch64-apple-darwin.tar.xz"
      sha256 "79dd14fccda9f7b529ddb4974e41f7ba249298c9f1627a94f16aa8a94bda4d99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.3.0/tribal-x86_64-apple-darwin.tar.xz"
      sha256 "7cc0388dd9419baff08e601dcf607e72e53bbcbf539f5f0d2f26fd50a68e0618"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.3.0/tribal-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d29c029e6890a3453f914691a1492342c0b205e220ddd7705c3cf724071a247b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.3.0/tribal-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30e3b8d02f74b58f24c9a58becddbdb2090ceb3be25b625be71ad208dfe3da9a"
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
