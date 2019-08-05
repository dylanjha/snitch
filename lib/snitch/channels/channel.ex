defmodule Snitch.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :mux_resource, :map
    field :mux_live_stream_id, :string
    field :name, :string
    field :slug, :string
    field :stream_key, :string

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:stream_key, :name, :slug, :mux_resource, :mux_live_stream_id])
    |> unique_constraint(:name, message: "Already a channel with this name")
    |> unique_constraint(:slug, message: "Already a channel with this name")
    |> validate_required([:name, :slug])
  end
end
