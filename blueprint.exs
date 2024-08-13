defmodule Blueprint do
  def config do
    [
      os: :archlinux,
      packages: [
        "atuin",
        "bat",
        "fd",
        "git-delta",
        "github-cli",
        "glibc-locales",
        "lazygit",
        "lsd",
        "neovim",
        "noto-fonts-emoji",
        "ripgrep",
        "starship",
        "ttf-nerd-fonts-symbols-mono",
        "wl-clipboard",
        "zoxide",
        {"wezterm", export: true}
      ]
    ]
  end
end
