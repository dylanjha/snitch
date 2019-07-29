defmodule Snitch.ChannelsTest do
  use Snitch.DataCase

  alias Snitch.Channels

  describe "channels" do
    alias Snitch.Channels.Channel

    @valid_attrs %{
      mux_resource: %{},
      name: "some name",
      slug: "some slug",
      stream_key: "some stream_key"
    }
    @update_attrs %{
      mux_resource: %{},
      name: "some updated name",
      slug: "some updated slug",
      stream_key: "some updated stream_key"
    }
    @invalid_attrs %{mux_resource: nil, name: nil, slug: nil, stream_key: nil}

    def channel_fixture(attrs \\ %{}) do
      {:ok, channel} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channels.create_channel()

      channel
    end

    test "list_channels/0 returns all channels" do
      channel = channel_fixture()
      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      channel = channel_fixture()
      assert Channels.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      assert {:ok, %Channel{} = channel} = Channels.create_channel(@valid_attrs)
      assert channel.mux_resource == %{}
      assert channel.name == "some name"
      assert channel.slug == "some slug"
      assert channel.stream_key == "some stream_key"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_channel(@invalid_attrs)
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{} = channel} = Channels.update_channel(channel, @update_attrs)
      assert channel.mux_resource == %{}
      assert channel.name == "some updated name"
      assert channel.slug == "some updated slug"
      assert channel.stream_key == "some updated stream_key"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, @invalid_attrs)
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Channels.change_channel(channel)
    end
  end
end
