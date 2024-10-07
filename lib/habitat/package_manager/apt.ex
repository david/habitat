defmodule Habitat.PackageManager.Apt do
  @sources_path "/etc/apt/sources.list.d"
  @keyring_path "/usr/share/keyrings"

  def install(packages) do
    for {pkg, opts} <- packages, Keyword.get(opts, :repo) do
      add_repo(pkg, Map.new(opts))
    end

    :ok = apt("update")
    :ok = apt("install", ["--no-install-recommends"] ++ for({pkg, _} <- packages, do: pkg))
  end

  defp apt(command, args \\ []) do
    {_, 0} = System.cmd("sudo", ["apt-get", "--assume-yes", command] ++ args)

    :ok
  end

  def add_repo(package_name, opts) do
    %{repo: repo, distribution: distribution, component1: component1, key: key} = opts

    key_path = Path.join(@keyring_path, "#{package_name}.gpg")

    {_, 0} =
      System.cmd("bash", [
        "-c",
        "curl -fsSL #{key} | sudo gpg --yes --dearmor -o #{key_path}"
      ])

    source_path = Path.join(@sources_path, "#{package_name}.list")
    deb_str = "deb [signed-by=#{key_path}] #{repo} #{distribution} #{component1}"

    {_, 0} = System.cmd("bash", ["-c", "echo \'#{deb_str}\' | sudo tee #{source_path}"])

    :ok
  end
end
