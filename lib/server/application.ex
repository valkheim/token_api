defmodule Server.Application do
  @moduledoc false

  use Application

  alias Server.Endpoint
  alias Server.Repo

  def start(_type, _args),
    do: Supervisor.start_link(children(), opts())

  defp children do
    [
      Endpoint,
      Repo
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: Server.Supervisor
    ]
  end
end
