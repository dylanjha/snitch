defmodule Snitch.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:stream_key, :string)
      add(:name, :string)
      add(:slug, :string)
      add(:mux_resource, :map)
      add(:mux_live_stream_id, :string)
      add(:mux_live_playback_id, :string)
      add(:mux_disconnected_at, :naive_datetime)
      timestamps()
    end

    create(unique_index(:channels, [:slug]))
  end
end
