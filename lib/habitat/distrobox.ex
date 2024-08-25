defmodule Habitat.Distrobox do
  def cmd(%{name: name}, args, opts \\ []) do
    cmd =
      ["distrobox", "enter", "--name", name, "--", "env"] ++
        if(Keyword.get(opts, :root), do: ["sudo"], else: []) ++
        args

    System.cmd("distrobox-host-exec", cmd)
  end

  def create(%{name: name, os: os, root: root}) do
    {_, 0} =
      System.cmd("distrobox-host-exec", [
        "distrobox",
        "create",
        "--image",
        to_string(os.image()) <> ":latest",
        "--name",
        name,
        "--home",
        root
      ])
  end

  def stop(%{name: name}) do
    System.cmd("distrobox-host-exec", ["distrobox", "stop", name])
  end

  def rm(%{name: name}) do
    System.cmd("distrobox-host-exec", ["distrobox", "rm", name])
  end
end
