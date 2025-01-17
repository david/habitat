defmodule Habitat.Distrobox do
  require Logger

  def shell(id, args) do
    cmd(id, ["bash", "-c", "#{Enum.join(args, " ")}"])
  end

  def cmd(id, args, opts \\ []) do
    cmd = ["distrobox", "enter", "--name", to_string(id), "--"] ++ args

    Logger.debug("Running `#{Enum.join(cmd, " ")}`")

    case System.cmd(hd(cmd), tl(cmd), [stderr_to_stdout: true] ++ opts) do
      {_, 0} ->
        :ok

      {err, _} ->
        Logger.debug(err)
        {:error, err}
    end
  end

  def create(name, image, home) do
    result =
      System.cmd(
        "distrobox",
        ["create", "--image", image, "--name", name, "--home", home]
      )

    case result do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end
  end

  def delete(id) do
    case System.cmd("distrobox", ["rm", id]) do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end
  end

  def stop(id) do
    case System.cmd("distrobox", ["stop", id]) do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end
  end
end
