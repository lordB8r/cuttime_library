defmodule Library.Factory do
  use ExMachina.Ecto, repo: Library.Repo

  import Ecto.Query

  alias Library.Catalogue.Book
  alias Library.Repo

  def first_name, do: Faker.Person.first_name()
  def last_name, do: Faker.Person.last_name()

  def title, do: Faker.File.file_name()

  def published_on, do: Faker.Date.date_of_birth()
  def isbn, do: Faker.Code.isbn()
  def author, do: first_name <> " " <> last_name()
  def cover_image_url, do: Faker.Internet.image_url()
  def stock, Enum.random(0..25)

  def book_factory do
    %Book{
      title:  title(),
      published_on: published_on(),
      isbn: isbn(),
      author: author(),
      cover_image_url:  cover_image_url(),
      stock:  stock()
    }
  end

end
