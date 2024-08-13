defmodule Habitat.Traits.Export do
  def post_install({name, export: true}) do
    {_, 0} = System.cmd("distrobox-export", ["--app", to_string(name)])
  end

  def post_install(_), do: nil
end
