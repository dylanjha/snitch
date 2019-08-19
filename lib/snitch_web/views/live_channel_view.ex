defmodule SnitchWeb.LiveChannelView do
  use Phoenix.LiveView

  #
  # When the controller calls live_render/3 this mount/2 function will get called
  # after the mount/2 function finishes then the render/1 function will get called
  # with the assigns
  #
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

  #
  # Since the mount/2 function called "subscribe" to with the identifier
  # "channel-updated:#{channel.id}" then anytime data is broadcast this
  # handle_info/2 function will run and we have the power to set new values
  # with set_assigns/2
  #
  # After we assign new values, the render/1 function will get called with the
  # new assigns
  #
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
