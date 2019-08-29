defmodule Server.Endpoints.Ping do
  @moduledoc "Handling /ping endpoints"

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  @content_type "application/json"

  get "/" do
    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(200, pong())
  end

  defp pong do
    Poison.encode!(%{
      text: "pong"
    })
  end
end
