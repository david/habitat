defmodule Habitat.OS.ArchLinux do
  alias Habitat.Container
  alias Habitat.PackageManager.Pacman

  @chaotic_aur_key "3056513887B78AEB"
  @chaotic_aur_keyring "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
  @chaotic_aur_mirror_list "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
  @key_server "hkp://keyserver.ubuntu.com:80"

  def image(), do: "archlinux"

  def install(container, packages) do
    Pacman.install(container, packages)
  end

  def uninstall(container, packages) do
    Pacman.uninstall(container, packages)
  end

  def post_create(container) do
    add_chaotic_aur(container)
  end

  defp add_chaotic_aur(container) do
    {_, 0} = Container.cmd(container, ["sudo", "pacman-key", "--init"])

    {_, 0} =
      Container.cmd(
        container,
        ["sudo", "pacman-key", "--recv-key", @chaotic_aur_key, "--keyserver", @key_server]
      )

    {_, 0} = Container.cmd(container, ["sudo", "pacman-key", "--lsign-key", @chaotic_aur_key])

    {_, 0} =
      Container.cmd(
        container,
        ["sudo", "pacman", "--upgrade", "--noconfirm", @chaotic_aur_keyring]
      )

    {_, 0} =
      Container.cmd(
        container,
        ["sudo", "pacman", "--upgrade", "--noconfirm", @chaotic_aur_mirror_list]
      )

    pacman_conf = File.read!("/etc/pacman.conf")

    unless pacman_conf =~ ~r/chaotic-aur/ do
      string =
        """
        #{pacman_conf}
        [chaotic-aur]
        Include = /etc/pacman.d/chaotic-mirrorlist
        """

      File.write!("/tmp/pacman.conf", string)

      {_, 0} = Container.cmd(container, ["sudo", "cp", "/tmp/pacman.conf", "/etc/pacman.conf"])
    end
  end
end
