defmodule Server.EndpointPingTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Server.Endpoint.init([])

  test "it returns pong" do
    conn = conn(:get, "/ping")

    conn = Server.Endpoint.call(conn, @opts)

    assert conn.state === :sent
    assert conn.status === 200

    assert conn.resp_body ===
             Poison.encode!(%{
               text: "pong"
             })
  end
end
