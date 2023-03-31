defmodule LibraryWeb.CheckoutLive do
  use LibraryWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:checked_out_books, %{})}
  end

  @impl Phoenix.LiveView
  def handle_event("search", _params, socket) do
    ### searching for books
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("checkout", _params, socket) do
    # book is checked out

    {:noreply, assign(socket, %{checked_out_books: %{}})}
  end
end
