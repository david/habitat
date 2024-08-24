defmodule Habitat.Tasks.Shells do
  alias Habitat.{Container, Feature, Programs}

  def init(container) do
    container
    |> Map.put_new(:shells, [:bash])
    |> Map.put_new(:env, %{})
  end

  def put(%{shells: shells} = container, shell, priority \\ :low, name, body) do
    if shell in shells do
      prefix =
        case priority do
          :high -> "000"
          :low -> "zzz"
        end

      Feature.put_string(container, body, "~/.config/#{shell}/rc.d/#{prefix}.#{name}.sh")
    else
      container
    end
  end

  def put_env(container, env) do
    update_in(container, [:env], &Map.merge(&1, env))
  end

  def pre_sync(%{shells: shells} = container) do
    Enum.reduce(shells, container, fn shell, c ->
      c
      |> select_shell(shell)
      |> prepare_env(shell)
    end)
  end

  defp select_shell(container, shell) do
    Programs.to_module(shell).pre_sync(container, %{})
  end

  def prepare_env(%{env: env} = container, shell) do
    vars =
      env
      |> Enum.map(fn {k, v} -> "#{k}=\"#{v}\"" end)
      |> Enum.join("\n")

    Feature.put_shell_config(container, shell, :high, "environment", vars)
  end

  def sync(%{shells: shells} = container) do
    {user, 0} = Container.cmd(container, ["whoami"])
    default = hd(shells)

    # Use sudo and username because otherwise this won't work inside distrobox
    Container.cmd(container, ["sudo", "chsh", "--shell", "/usr/bin/#{default}", String.trim(user)])
  end
end
