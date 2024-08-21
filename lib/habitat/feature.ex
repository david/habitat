defmodule Habitat.Feature do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__).Guards
      import unquote(__MODULE__).DSL
      require Logger
    end
  end

  defmodule Guards do
    defguard is_enabled(val) when val == true or is_map(val)
  end

  defmodule DSL do
    import Habitat.Feature.Guards

    def put_file(container, from, to) do
      update_in(container, [:files], &[{from, to} | &1])
    end

    def put_files(container, files) do
      update_in(container, [:files], &(&1 ++ files))
    end

    def put_package(container, package) do
      update_in(container, [:packages], &[package | &1])
    end

    def put_packages(container, packages) do
      update_in(container, [:packages], &(&1 ++ packages))
    end

    def put_hook(container, hook, name, callback) do
      update_in(container, [:hooks, hook], &Map.put(&1, name, callback))
    end

    def put_hooks(container, hooks) do
      update_in(container, [:hooks], &Map.merge(&1, hooks))
    end

    def put_text(container, to, text) do
      put_file(container, {:text, text}, to)
    end

    def put_shell_config(container, shell, priority \\ :low, name, body) do
      if is_enabled(get_in(container, [:programs, shell])) do
        prefix =
          case priority do
            :high -> "000"
            :low -> "zzz"
          end

        put_file(container, {:text, body}, "~/.config/#{shell}/rc.d/#{prefix}.#{name}.sh")
      else
        container
      end
    end
  end
end