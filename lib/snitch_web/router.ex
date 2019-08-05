defmodule SnitchWeb.Router do
  use SnitchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SnitchWeb do
    pipe_through :browser

    get "/", ChannelController, :new

    get "/c/:channel_slug", ChannelController, :show

    resources "/channels", ChannelController, only: [:index, :new, :create] do
      post "/create_stream_key", ChannelController, :create_stream_key
    end
  end

  scope "/", SnitchWeb do
    pipe_through :api
    post "/webhooks/mux", WebhookController, :mux
  end
end
