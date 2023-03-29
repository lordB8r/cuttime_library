# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Library.Repo.insert!(%Library.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Faker.Person
alias Faker.Internet
alias Library.Repo
# alias Library.Catalogues
# alias Library.Catalogues.Book
# alias Library.Accounts.Member

# Repo.delete_all(Book)
# Repo.delete_all(Member)

# Enum.map(0..20, fn _ ->
#   Accounts.create_user(%{
#     first_name: Person.first_name(),
#     last_name: Person.last_name(),
#     email: Internet.email()
#   })
# end)

### import from .csv, generate all books
