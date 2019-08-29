defmodule Server.Endpoints.Tokens.Test do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Server.Endpoint.init([])

  test "it generates a token" do
    body = Poison.encode!(%{user: "user", pass: "pass"})

    conn =
      conn(:post, "/tokens", body)
      |> put_req_header("content-type", "application/json")

    conn = Server.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200

    assert Poison.decode!(conn.resp_body, as: %Server.Schemas.Tokens{})
  end

  test "it cannot generate a token without user" do
    body = Poison.encode!(%{pass: "pass"})

    conn =
      conn(:post, "/tokens", body)
      |> put_req_header("content-type", "application/json")

    conn = Server.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert Poison.decode!(conn.resp_body) == %{"error" => "Missing credentials"}
  end

  test "it cannot generate a token without pass" do
    body = Poison.encode!(%{user: "user"})

    conn =
      conn(:post, "/tokens", body)
      |> put_req_header("content-type", "application/json")

    conn = Server.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert Poison.decode!(conn.resp_body) == %{"error" => "Missing credentials"}
  end
end
