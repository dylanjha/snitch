defmodule Snitch.Repo do
  use Ecto.Repo,
    otp_app: :snitch,
    adapter: Ecto.Adapters.Postgres
end
