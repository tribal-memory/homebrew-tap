class Tribal < Formula
  desc "Capture tribal knowledge. Give it to your agents."
  homepage "https://github.com/tribal-memory/tribal"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.4.1/tribal-aarch64-apple-darwin.tar.xz"
      sha256 "3f2778ce67c2e55a9d52d13cfab075e05396bde4da47efabd78910be725f8a7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.4.1/tribal-x86_64-apple-darwin.tar.xz"
      sha256 "fe302b5cef49be6fbcba0fa6cd328d488843f73770177d6fd3dc392cfdc2ddc8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.4.1/tribal-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc11d09151f7e7c95c98c93c0d7860dde89006a810beba729fb8b60b125cdab7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.4.1/tribal-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b956ef3ab9fcca38a7db9be0f05947550b17ce11ea85ddd9ef550f3624cbdbc4"
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
