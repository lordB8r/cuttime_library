defmodule LibraryWeb.MemberControllerTest do
  use LibraryWeb.ConnCase

  import Library.AccountsFixtures

  @create_attrs %{first_name: "some first_name", last_name: "some last_name"}
  @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
  @invalid_attrs %{first_name: nil, last_name: nil}

  describe "index" do
    test "lists all members", %{conn: conn} do
      conn = get(conn, ~p"/members")
      assert html_response(conn, 200) =~ "Listing Members"
    end
  end

  describe "new member" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/members/new")
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "create member" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/members", member: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/members/#{id}"

      conn = get(conn, ~p"/members/#{id}")
      assert html_response(conn, 200) =~ "Member #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/members", member: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "edit member" do
    setup [:create_member]

    test "renders form for editing chosen member", %{conn: conn, member: member} do
      conn = get(conn, ~p"/members/#{member}/edit")
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "update member" do
    setup [:create_member]

    test "redirects when data is valid", %{conn: conn, member: member} do
      conn = put(conn, ~p"/members/#{member}", member: @update_attrs)
      assert redirected_to(conn) == ~p"/members/#{member}"

      conn = get(conn, ~p"/members/#{member}")
      assert html_response(conn, 200) =~ "some updated first_name"
    end

    test "renders errors when data is invalid", %{conn: conn, member: member} do
      conn = put(conn, ~p"/members/#{member}", member: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "delete member" do
    setup [:create_member]

    test "deletes chosen member", %{conn: conn, member: member} do
      conn = delete(conn, ~p"/members/#{member}")
      assert redirected_to(conn) == ~p"/members"

      assert_error_sent 404, fn ->
        get(conn, ~p"/members/#{member}")
      end
    end
  end

  defp create_member(_) do
    member = member_fixture()
    %{member: member}
  end
end
