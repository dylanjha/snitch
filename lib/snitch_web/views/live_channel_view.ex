defmodule SnitchWeb.LiveChannelView do
  use Phoenix.LiveView

  def mount(session, socket) do
    channel = session[:channel]
    if connected?(socket), do: SnitchWeb.Endpoint.subscribe("channel-updated:#{channel.id}")
    playback_url = Snitch.Channels.playback_url_for_channel(channel)

    {
      :ok,
      socket
      |> assign(channel: channel)
      |> assign(playback_url: playback_url)
    }
  end

  def render(assigns) do
    playback_url = assigns[:playback_url]

    case(playback_url) do
      nil ->
        SnitchWeb.ChannelView.render("show.html", assigns)

      _ ->
        SnitchWeb.ChannelView.render("show_active.html", assigns)
    end
  end

  def handle_info(channel, socket) do
    playback_url = Snitch.Channels.playback_url_for_channel(channel)

    {
      :noreply,
      socket
      |> assign(channel: channel)
      |> assign(playback_url: playback_url)
    }
  end
end
