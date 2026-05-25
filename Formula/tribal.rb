class Tribal < Formula
  desc "Capture tribal knowledge. Give it to your agents."
  homepage "https://github.com/tribal-memory/tribal"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.1/tribal-aarch64-apple-darwin.tar.xz"
      sha256 "24b53505c109ba762fa5f7d74bc1b1caf0afda25c1406281efd32fceb940e12b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.1/tribal-x86_64-apple-darwin.tar.xz"
      sha256 "c1912a24a0ba8e7cd434ab829751a7c2b7e15908bf1863ccc1fe738d55dc4701"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.1/tribal-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "504be1eba309448e8a6f366025a6d45a3ab56d8e2e28c059712d79faf606f0a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.1/tribal-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a37d2f8ec1975e781d26239c862b524069a187fc8eaecb93eb8958fef4f2538e"
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
