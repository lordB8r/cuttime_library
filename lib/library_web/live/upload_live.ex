defmodule LibraryWeb.UploadLive do
  use LibraryWeb, :live_view

  # alias Library.Catalogue
  # alias Library.Catalogue.Book
  alias Library.Utility

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, %{})
     |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :csv, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(
        socket,
        :csv,
        fn %{path: path}, entry ->
          Path.basename(path) |> IO.inspect(label: "basename:: upload_live.ex:35")
          :code.priv_dir(:library) |> IO.inspect(label: "upload_live.ex:36")
          entry |> IO.inspect(label: "upload_live.ex:37")

          dest =
            Path.join([
              :code.priv_dir(:library),
              "static",
              "uploads",
              Path.basename(path)
            ]) <> ".csv"

          dest |> IO.inspect(label: "upload_live.ex:45")
          File.cp!(path, dest)

          {:ok, file_path: dest}
        end
      )

    {:noreply,
     socket
     |> push_redirect(to: ~p"/books-import"), :import_books, &(&1 ++ uploaded_files)}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
