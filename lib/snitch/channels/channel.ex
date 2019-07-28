defmodule Snitch.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :mux_resource, :map
    field :name, :string
    field :slug, :string
    field :stream_key, :string

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:stream_key, :name, :slug, :mux_resource])
    |> validate_required([:name, :slug])
  end
end