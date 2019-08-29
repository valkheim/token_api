defmodule Server.Helpers do
  @moduledoc "Helper functions for Server"

  def generate_seed do
    (:random.uniform() * :math.pow(10, 9)) |> round
  end

  def get_timestamp do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
