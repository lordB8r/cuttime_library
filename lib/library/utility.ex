defmodule Library.Utility do
  alias Library.Catalogue.Book

  @moduledoc """
  Utilities for working with the Library application

  Includes:

  decod_csv(filename, type)

  process_csv(path)
  """

  @doc """
  Passing the filename, if the file is imported, the "import" type needs to be noted.

  $> decode_csv(anything.csv, "import")

  Results will come back in the shape of a Map containing a list of Passed and Failed upserts
  $> %{
  failed: [
    #Ecto.Changeset<
      action: :insert,
      changes: %{
        author: "https://covers.openlibrary.org/b/isbn/9781592911219-L.jpg",
        cover_image_url: "5",
        isbn: "9781592911219",
        published_on: ~D[2011-01-01],
        title: "Fevre Dream"
      },
      errors: [stock: {"can't be blank", [validation: :required]}],
      data: #Library.Catalogue.Book<>,
      valid?: false
    >
  ],
  passed: [
    %Library.Catalogue.Book{
      __meta__: #Ecto.Schema.Metadata<:loaded, "books">,
      id: 5,
      author: "Christopher Moore",
      count_checked_out: 0,
      cover_image_url: "https://covers.openlibrary.org/b/isbn/9780060590284-L.jpg",
      stock: 6,
      isbn: "9780060590284",
      published_on: ~D[2007-01-01],
      title: "A dirty job",
      inserted_at: ~N[2023-03-30 23:29:05],
      updated_at: ~N[2023-03-30 23:29:05]
    }]
  """
  def decode_csv(filename, type) when type == "import" do
    Path.join([Application.app_dir(:library), "priv", "imports", filename])
    |> process_csv()
  end

  def decode_csv(filename, _type) do
    Path.join([Application.app_dir(:library), "priv", "repo", "data", filename])
    |> process_csv()
  end

  def process_csv(path) do
    path
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.reduce(%{passed: [], failed: []}, fn
      {:ok, book}, acc = %{passed: passed, failed: failed} ->
        %Book{}
        |> Book.changeset(%{
          title: Map.get(book, "title"),
          published_on: Date.from_iso8601!(Map.get(book, "published_on") <> "-01-01"),
          isbn: Map.get(book, "isbn"),
          author: Map.get(book, "author"),
          cover_image_url: Map.get(book, "cover_image_url"),
          stock: Map.get(book, "stock")
        })
        |> Library.Repo.insert(
          on_conflict: [inc: [stock: Map.get(book, "stock")]],
          conflict_target: [:isbn]
        )
        |> case do
          {:ok, book} -> %{acc | passed: [book | passed]}
          {:error, changeset} -> %{acc | failed: [changeset | failed]}
        end
    end)
  end
end
