defmodule MultiRooms.Repo do
  use Ecto.Repo,
    otp_app: :multiRooms,
    adapter: Ecto.Adapters.Postgres
end
