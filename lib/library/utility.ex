defmodule Library.Utility do
  alias Library.Catalogue.Book

  # def csv_decoder(filename, path \\ "/priv/static/uploads") do
  #   Path.join([Application.app_dir(:library), path])
  #   |> Path.expand(__DIR__)
  #   |> File.stream!()
  #   |> CSV.decode(headers: true)
  #   |> Enum.map(fn data -> data end)
  # end

  def decode_csv(filename, type) when type == "import" do
    Path.join([Application.app_dir(:library), "priv", "imports", filename])
    |> process_csv()
  end

  def decode_csv(filename, _type) do
    Path.join([Application.app_dir(:library), "priv", "repo", "data", filename])
    |> process_csv()
  end

  defp process_csv(path) do
    books_chunk =
      path
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Enum.map(fn
        {:ok,
         %{
           "title" => title,
           "published_on" => published_on,
           "isbn" => isbn,
           "author" => author,
           "cover_image_url" => cover_image_url,
           "stock" => stock
         }} ->
          date = published_on <> "-01-01"

          %Book{}
          |> Book.changeset(%{
            title: title,
            published_on: Date.from_iso8601!(date),
            isbn: isbn,
            author: author,
            cover_image_url: cover_image_url,
            stock: stock
          })
          |> Library.Repo.insert(on_conflict: [inc: [stock: stock]], conflict_target: [:isbn])
      end)

    books_chunk
    |> IO.inspect(label: "utility.ex:46")

    # |> Library.Repo.insert(
    #   & &1.data,
    #   on_conflict: {:inc[stock: & &1.data.stock]},
    #   conflict_target: [:isbn]
    # )
  end
end
