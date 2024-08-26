defmodule Habitat.Distrobox do
  alias Habitat.OS

  def cmd(id, args, opts \\ []) do
    cmd =
      ["distrobox", "enter", "--name", to_string(id), "--", "env"] ++
        if(Keyword.get(opts, :root), do: ["sudo"], else: []) ++
        args

    case System.cmd("distrobox-host-exec", cmd) do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end
  end

  def create(%{id: id, os: os, root: root}) do
    result =
      System.cmd("distrobox-host-exec", [
        "distrobox",
        "create",
        "--image",
        to_string(OS.get(os).image()) <> ":latest",
        "--name",
        to_string(id),
        "--home",
        root
      ])

    case result do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end
  end

  def delete(%{id: id}) do
    case System.cmd("distrobox-host-exec", ["distrobox", "rm", to_string(id)]) do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end
  end

  def stop(%{id: id}) do
    case System.cmd("distrobox-host-exec", ["distrobox", "stop", to_string(id)]) do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end
  end
end
