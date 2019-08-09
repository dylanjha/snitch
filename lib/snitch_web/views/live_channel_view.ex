defmodule SnitchWeb.LiveChannelView do
  use Phoenix.LiveView

  def mount(session, socket) do
    channel = session[:channel]
    if connected?(socket), do: SnitchWeb.Endpoint.subscribe("channel-updated:#{channel.id}")

    {
      :ok,
      set_assigns(channel, socket)
    }
  end

  def render(%{playback_url: nil} = assigns),
    do: SnitchWeb.ChannelView.render("show.html", assigns)

  def render(assigns), do: SnitchWeb.ChannelView.render("show_active.html", assigns)

  def handle_info(channel, socket) do
    {
      :noreply,
      set_assigns(channel, socket)
    }
  end

  def set_assigns(channel, socket) do
    playback_url = Snitch.Channels.playback_url_for_channel(channel)

    socket
    |> assign(name: channel.name)
    |> assign(status: channel.mux_resource["status"])
    |> assign(connected: channel.mux_resource["connected"])
    |> assign(stream_key: channel.stream_key)
    |> assign(playback_url: playback_url)
  end
end
