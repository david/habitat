defmodule Habitat.Tasks.Shells do
  alias Habitat.Programs

  def init(container) do
    Map.put_new(container, :shells, [:bash])
  end

  def put(%{shells: shells} = container, shell, priority \\ :low, name, body) do
    if shell in shells do
      prefix =
        case priority do
          :high -> "000"
          :low -> "zzz"
        end

      put_string(container, body, "~/.config/#{shell}/rc.d/#{prefix}.#{name}.sh")
    else
      container
    end
  end

  def pre_sync(%{shells: shells} = container) do
    for shell <- shells do
      Programs.to_module(shell).pre_sync(container, %{})
    end
  end

  def sync(container, _) do
    {user, 0} = Container.cmd(container, ["whoami"])
    default = hd(container.shells)

    # Use sudo and username because otherwise this won't work inside distrobox
    Container.cmd(container, ["sudo", "chsh", "--shell", "/usr/bin/#{default}", String.trim(user)])
  end
end
