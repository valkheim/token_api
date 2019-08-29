defmodule Server.Schemas.Token do
  @moduledoc "Tokens table schema"

  use Ecto.Schema

  import Ecto.Changeset
  import Server.Helpers

  @derive {Poison.Encoder, except: [:__meta__]}
  schema "tokens" do
    field(:user)
    field(:pass)
    field(:token)
    field(:issued_at, :integer)
    field(:expire_at, :integer)
    field(:seed, :integer)
  end

  @fields [:user, :pass, :token, :issued_at, :expire_at]

  def registration_changeset(struct, params) do
    struct
    |> cast(params |> get_token_metas, @fields)
    |> validate_required(@fields)
    |> unique_constraint(:user, name: :users_user_index)
  end

  defp get_token_metas(params) do
    issued_at = get_timestamp()
    {:ok, ttl} = Application.fetch_env(:server, :ttl)
    expire_at = issued_at + ttl
    seed = generate_seed()

    metas =
      params
      |> Map.put(:issued_at, issued_at)
      |> Map.put(:expire_at, expire_at)
      |> Map.put(:seed, seed)

    token = generate_token(params.user, issued_at, expire_at, seed)
    metas |> Map.put(:token, token)
  end

  defp generate_token(user, issued_at, expire_at, seed) do
    hash = Argon2.add_hash("#{user}#{issued_at}#{expire_at}#{seed}")
    :crypto.hash(:md5, hash.password_hash) |> Base.encode16(case: :lower)
  end
end
