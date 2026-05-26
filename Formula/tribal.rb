class Tribal < Formula
  desc "Capture tribal knowledge. Give it to your agents."
  homepage "https://github.com/tribal-memory/tribal"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.2/tribal-aarch64-apple-darwin.tar.xz"
      sha256 "25543bafb40f139d3eed91c3dc840106e04f190274c6b1c1802b79d8e05f5a24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.2/tribal-x86_64-apple-darwin.tar.xz"
      sha256 "a063a2d98c9cfffe32979f6d7318245d76bfd671ab4d158a6a43447a21b3ba7c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.2/tribal-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b647d14fe6aededc0380770308134fc41a97e3a5e35ef02519887320bed5fa2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.2/tribal-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "725c07b978f814fcf25fb711d17ed83a6451aa36543ee78c9f6056d0e99940ac"
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
