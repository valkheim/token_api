defmodule Server.Endpoint do
  @moduledoc "Handling API endpoints"

  use Plug.Router
  use Plug.Debugger
  use Plug.ErrorHandler

  alias Plug.Cowboy
  alias Server.Endpoints.Ping
  alias Server.Endpoints.Tokens

  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    with {:ok, [port: port] = config} <- config() do
      Logger.info("Starting server at http://localhost:#{port}/")
      Cowboy.http(__MODULE__, [], config)
    end
  end

  forward("/ping", to: Ping)
  forward("/tokens", to: Tokens)

  match _ do
    send_resp(conn, 404, "Not found!")
  end

  defp config, do: Application.fetch_env(:server, __MODULE__)

  def handle_errors(%{status: status} = conn, %{kind: _kind, reason: _reason, stack: _stack}),
    do: send_resp(conn, status, Poison.encode!(%{error: "Something went wrong"}))
end
