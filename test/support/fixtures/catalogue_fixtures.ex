defmodule Library.CatalogueFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Library.Catalogue` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        author: "some author",
        count_checked_out: 42,
        cover_image_url: "some cover_image_url",
        initial_stock: 42,
        isbn: "some isbn",
        published_date: ~D[2023-03-28],
        title: "some title"
      })
      |> Library.Catalogue.create_book()

    book
  end
end
