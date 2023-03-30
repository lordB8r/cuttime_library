defmodule Library.UtilityTest do
  use Library.DataCase

  alias Library.Repo
  alias Library.Utility
  alias Library.Catalogue.Book

  describe "decode_csv/2" do
    test "works with properly formed csv" do
      csv = "test/support/fixtures/csv_valid.csv"
      response = Utility.process_csv(csv)
      assert length(Map.get(response, :failed)) == 0
    end

    test "fails with mal-formed csv" do
      csv = "test/support/fixtures/csv_invalid.csv"
      response = Utility.process_csv(csv)
      assert length(Map.get(response, :failed)) > 0
    end

    test "increments book count on pre-existing book" do
      csv = "test/support/fixtures/csv_valid.csv"
      response = Utility.process_csv(csv)
      [initial_book | _] = Map.get(response, :passed)

      assert initial_book.stock > 0

      Utility.process_csv(csv)
      updated_book = Repo.get_by!(Book, id: initial_book.id)

      assert updated_book.stock == initial_book.stock * 2
    end

    test "sets published_on date correctly to first of year" do
      csv = "test/support/fixtures/csv_valid.csv"
      response = Utility.process_csv(csv)
      [initial_book | _] = Map.get(response, :passed)

      assert Date.day_of_year(initial_book.published_on) == 1
    end
  end
end
