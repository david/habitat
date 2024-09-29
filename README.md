# Habitat

Declarative configuration for the Linux distro you already use.

## Example Usage

```elixir
defmodule Sys.Blueprint do
  use Habitat.Blueprint

  def hosts do
    [
      [
        name: "timbuktu",
        containers: containers()
      ]
    ]
  end

  defp containers do
    [
      [
        id: :my_ruby_on_rails_project,
        root: "~/sys",
        editing: [
          style: :vi
        ],
        modules: [
          mysql: "8.0",
          nodejs: [
            version: "18"
            package_manager: :yarn
          ],
          ruby: "3.3",
        ]
      # Plus several additional half-supported, clumsily-implemented
      # modules and options...
    ]
  ]
end
```

## Installation

I haven't considered that yet.
