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
    create_params = %{name: name}
    slug = Slugger.slugify_downcase(name)
    create_params = Map.put(create_params, :slug, slug)

    case Channels.create_channel(create_params) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "Channel created successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_stream_key(conn, %{"channel_id" => id}) do
    channel = Channels.get_channel!(id)

    if channel.stream_key do
      conn
      |> put_flash(:error, "Already have a stream key")
      |> redirect(to: Routes.channel_path(conn, :show, channel.slug))
    else
      case Mux.Video.LiveStreams.create(Mux.client(), %{
             playback_policy: "public",
             test: true,
             new_asset_settings: %{playback_policy: "public"},
             reconnect_window: 20
           }) do
        {:ok, live_stream, _env} ->
          stream_key = live_stream["stream_key"]
          live_stream_id = live_stream["id"]

          case Channels.update_channel(channel, %{
                 stream_key: stream_key,
                 mux_resource: live_stream,
                 mux_live_stream_id: live_stream_id
               }) do
            {:ok, channel} ->
              conn
              |> redirect(to: Routes.channel_path(conn, :show, channel.slug))

            {:error, %Ecto.Changeset{} = _changeset} ->
              conn
              |> put_flash(:error, "Error saving stream key")
              |> redirect(to: Routes.channel_path(conn, :show, channel.slug))
          end

        {:error, _, err} ->
          IO.inspect(err)

          conn
          |> put_flash(:error, "Error creating live stream")
          |> redirect(to: Routes.channel_path(conn, :show, channel.slug))
      end
    end
  end

  def show(conn, %{"channel_slug" => channel_slug}) do
    channel = Channels.get_channel_by_slug!(channel_slug)

    if channel.stream_key do
      Phoenix.LiveView.Controller.live_render(conn, SnitchWeb.LiveChannelView,
        session: %{channel: channel}
      )
    else
      render(conn, "show_create_stream_key.html", channel: channel)
    end
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
