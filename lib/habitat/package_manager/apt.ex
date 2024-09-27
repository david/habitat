defmodule Habitat.PackageManager.Apt do
  alias Habitat.Distrobox

  @sources_path "/etc/apt/sources.list.d"
  @keyring_path "/usr/share/keyrings"

  def install(container_id, package, opts) do
    if Keyword.get(opts, :repo) do
      add_repo(container_id, package, Map.new(opts))
    end

    apt(container_id, ["install", "--no-install-recommends", package])
  end

  defp apt(container_id, args) do
    cmd = ["sudo", "apt-get", "--assume-yes"] ++ args

    Distrobox.cmd(container_id, cmd)
  end

  def add_repo(container_id, package_name, opts) do
    %{repo: repo, distribution: distribution, component1: component1, key: key} = opts

    key_path = Path.join(@keyring_path, "#{package_name}.gpg")

    :ok =
      Distrobox.shell(container_id, [
        "curl -fsSL #{key} | sudo gpg --yes --dearmor -o #{key_path}"
      ])

    source_path = Path.join(@sources_path, "#{package_name}.list")
    deb_str = "deb [signed-by=#{key_path}] #{repo} #{distribution} #{component1}"

    :ok = Distrobox.shell(container_id, ["echo \'#{deb_str}\' | sudo tee #{source_path}"])
    :ok = Distrobox.cmd(container_id, ["sudo", "apt-get", "update"])
  end
end
