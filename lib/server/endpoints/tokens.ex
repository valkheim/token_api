defmodule Server.Endpoints.Tokens do
  @moduledoc "Handling /tokens endpoints"

  import Ecto.Query

  use Plug.Router
  use Plug.ErrorHandler

  alias Server.Repo
  alias Server.Schemas.Token

  plug(:match)
  plug(:dispatch)

  @content_type "application/json"

  get "/" do
    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(200, Poison.encode!(get_tokens()))
  end

  defp get_tokens do
    Repo.all(Token)
  end

  post "/" do
    {status, body} =
      case conn.body_params do
        %{"user" => user, "pass" => pass} -> {200, generate_token(user, pass)}
        %{"user" => _} -> {422, missing_credentials()}
        %{"pass" => _} -> {422, missing_credentials()}
      end

    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(status, body)
  end

  get "/:token" do
    case Repo.get_by(Token, token: token) do
      nil -> send_resp(conn, 404, Poison.encode!(%{valid: false}))
      _ -> send_resp(conn, 200, Poison.encode!(%{valid: true}))
    end
  end

  defp generate_token(user, pass) do
    result =
      case Repo.get_by(Token, user: user) do
        nil -> %Token{}
        token -> token
      end
      |> Token.registration_changeset(%{user: user, pass: pass})
      |> Repo.insert_or_update()

    case result do
      {:ok, struct} -> Poison.encode!(%{token: struct.token})
      {:error, _} -> Poison.encode!(%{error: "Cannot add token"})
    end
  end

  defp missing_credentials do
    Poison.encode!(%{error: "Missing credentials"})
  end
end
