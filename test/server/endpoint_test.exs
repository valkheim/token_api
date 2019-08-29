defmodule Server.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Server.Endpoint.init([])

  test "it returns 404 when no route matches" do
    conn = conn(:get, "/404")

    conn = Server.Endpoint.call(conn, @opts)

    assert conn.state === :sent
    assert conn.status === 404
  end
end
