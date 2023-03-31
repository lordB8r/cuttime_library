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
        stock: 42,
        isbn: "some isbn",
        published_on: ~D[2023-03-28],
        title: "some title"
      })
      |> Library.Catalogue.create_book()

    book
  end

  def book_available_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        author: "some author",
        count_checked_out: 0,
        cover_image_url: "some cover_image_url",
        stock: 42,
        isbn: "some isbn",
        published_on: ~D[2023-03-28],
        title: "some title"
      })
      |> Library.Catalogue.create_book()

    book
  end
end
