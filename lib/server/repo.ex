defmodule Server.Repo do
  @moduledoc "Postgres adapter"

  use Ecto.Repo,
    otp_app: :server,
    adapter: Ecto.Adapters.Postgres
end
