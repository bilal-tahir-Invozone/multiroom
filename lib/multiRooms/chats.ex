defmodule MultiRooms.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias MultiRooms.Repo

  alias MultiRooms.Chats.Message
  def del_room_id(room) do
    Repo.delete(room)
  end

  def list_messages_by_room(room) do
    qry = from m in Message,
          where: m.room == ^room,
          order_by: [asc: m.inserted_at]
    Repo.all(qry)

  end


  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    # IO.inspect attrs
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(message, attrs) do
    # IO.puts "messages"
    # IO.inspect message
    # IO.puts "End"
    # IO.puts "attrs"
    # IO.inspect attrs
    # IO.puts "End"
    IO.puts "here is updating operation"

    Repo.get(Message,message.id)
    |> IO.inspect
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
