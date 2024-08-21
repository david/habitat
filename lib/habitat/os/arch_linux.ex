defmodule Habitat.OS.ArchLinux do
  alias Habitat.Container
  import Habitat.PackageManager.Pacman

  @chaotic_aur_key "3056513887B78AEB"
  @chaotic_aur_keyring "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
  @chaotic_aur_mirror_list "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
  @key_server "hkp://keyserver.ubuntu.com:80"

  def image(), do: "archlinux"
end
