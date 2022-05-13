defmodule Loop.Repo do
  use Ecto.Repo,
    otp_app: :loop,
    adapter: Ecto.Adapters.Postgres
end
