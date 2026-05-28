class Tribal < Formula
  desc "Capture tribal knowledge. Give it to your agents."
  homepage "https://github.com/tribal-memory/tribal"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.4/tribal-aarch64-apple-darwin.tar.xz"
      sha256 "28638bc7f7d77a563906258f2be48852161e8c846688f53dfe0075b7afca5985"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.4/tribal-x86_64-apple-darwin.tar.xz"
      sha256 "c31a3e98fe5e7b9e98b0d11c7c6c614f393d4f4cea379f067a10779ca6270216"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.4/tribal-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea0f9e6b5824af18a36d562683c69541a799a712389c1c07a6326b5c2a60c46e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tribal-memory/tribal/releases/download/v0.2.4/tribal-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "604c54d42b7feafa90b3090b33b2128618801353561bdc62f937ba0f9bdeb87e"
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
