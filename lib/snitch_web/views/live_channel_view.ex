defmodule SnitchWeb.LiveChannelView do
  use Phoenix.LiveView

  def mount(session, socket) do
    channel = session[:channel]
    if connected?(socket), do: SnitchWeb.Endpoint.subscribe("channel-updated:#{channel.id}")
    {:ok, assign(socket, channel: channel)}
  end

  def render(assigns) do
    channel = assigns[:channel]

    case(channel.mux_resource["status"]) do
      "active" ->
        SnitchWeb.ChannelView.render("show_active.html", assigns)

      status ->
        SnitchWeb.ChannelView.render("show.html", assigns)
    end
  end

  def handle_info(channel, socket) do
    {:noreply, assign(socket, channel: channel)}
  end
end
