defmodule Habitat.Programs.Ruby do
  use Habitat.Feature

  def pre_sync(container, spec) do
    Logger.info("Configuring ruby")

    container
    |> put_packages(["rust", "libffi", "libyaml", "openssl", "zlib"])
    |> put_package(:mise, "ruby", version: version(spec))
  end

  defp version([]), do: nil
  defp version(v) when is_binary(v), do: v
  defp version(opts) when is_list(opts), do: Keyword.get(opts, :version, version([]))
end
