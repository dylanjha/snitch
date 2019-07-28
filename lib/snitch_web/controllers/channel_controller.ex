defmodule SnitchWeb.ChannelController do
  use SnitchWeb, :controller

  alias Snitch.Channels
  alias Snitch.Channels.Channel

  def index(conn, _params) do
    channels = Channels.list_channels()
    render(conn, "index.html", channels: channels)
  end

  def new(conn, _params) do
    changeset = Channels.change_channel(%Channel{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"channel" => channel_params}) do
    {:ok, name} = Map.fetch(channel_params, "name")
    slug = Slugger.slugify_downcase name
    channel_params =  Map.put(channel_params, "slug", slug)
    case Channels.create_channel(channel_params) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "Channel created successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect changeset
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_stream_key(conn, %{"channel_id" => id}) do
    channel = Channels.get_channel!(id)
    if (false && channel.stream_key) do
      conn
        |> put_flash(:error, "Already have a stream key")
        |> redirect(to: Routes.channel_path(conn, :show, channel))
    else
      case Mux.Video.LiveStreams.create(Mux.client(), %{playback_policy: "public", new_asset_settings: %{playback_policy: "public"}}) do
        {:ok, live_stream, _env} ->
          {:ok, stream_key} = Map.fetch(live_stream, "stream_key")
          case Channels.update_channel(channel, %{stream_key: stream_key, mux_resource: live_stream}) do
            {:ok, channel} ->
              conn
              |> put_flash(:info, "Live stream is created")
              |> redirect(to: Routes.channel_path(conn, :show, channel))

            {:error, %Ecto.Changeset{} = changeset} ->
              conn
              |> put_flash(:error, "Error saving stream key")
              |> redirect(to: Routes.channel_path(conn, :show, channel))
          end
        {:error, _, err} ->
          IO.inspect err
          conn
          |> put_flash(:error, "Error creating live stream")
          |> redirect(to: Routes.channel_path(conn, :show, channel))
      end
    end
  end

  def show(conn, %{"id" => id}) do
    channel = Channels.get_channel!(id)
    render(conn, "show.html", channel: channel)
  end

  def edit(conn, %{"id" => id}) do
    channel = Channels.get_channel!(id)
    changeset = Channels.change_channel(channel)
    render(conn, "edit.html", channel: channel, changeset: changeset)
  end

  def update(conn, %{"id" => id, "channel" => channel_params}) do
    channel = Channels.get_channel!(id)

    case Channels.update_channel(channel, channel_params) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "Channel updated successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", channel: channel, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    channel = Channels.get_channel!(id)
    {:ok, _channel} = Channels.delete_channel(channel)

    conn
    |> put_flash(:info, "Channel deleted successfully.")
    |> redirect(to: Routes.channel_path(conn, :index))
  end
end
