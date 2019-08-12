# Snitch

Snitch is Twitch, for snitches. This is an out of the box Elixir/Phoenix
application.

This application uses [Mux Live Stream](https://mux.com/live) and Phoenix Live View.

## Getting started

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Create a .env file based on .env.sample
  * Start Phoenix endpoint with the environment variables loaded `source .env && mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Deploying

This is a straight-forward Elixir/Phoenix application so it should be deployable like any other
Phoenix application.

Currently, the demo [snitch.world](https://snitch.world) is deployed using [gigalixir](https://gigalixir.com/). If
you deploy there make sure you set the environment variables that are defined in `.env.sample`.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

