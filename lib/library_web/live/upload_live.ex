defmodule LibraryWeb.UploadLive do
  use LibraryWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, %{passed: [], failed: []})
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
    file_path =
      consume_uploaded_entries(
        socket,
        :csv,
        fn %{path: path}, _entry ->
          filename = Path.basename(path) <> ".csv"
          dest = Path.join("priv/static/uploads", filename)

          File.cp!(path, dest)
          {:ok, filename}
        end
      )

    uploaded = Library.Utility.decode_csv(file_path, "import")

    {:noreply, assign(socket, %{uploaded_files: uploaded})}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
