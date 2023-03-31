defmodule Library.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Library.Accounts` context.
  """

  @doc """
  Generate a member.
  """
  def member_fixture(attrs \\ %{}) do
    {:ok, member} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> Library.Accounts.create_member()

    member
  end
end
