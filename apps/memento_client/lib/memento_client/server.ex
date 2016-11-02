defmodule MementoClient.Server do

  alias MementoServer.Proto

  def is_running? do
    case ping do
      {:ok, _} -> true
      _ -> false
    end
  end

  def server_url do
    "http://127.0.0.1:9876"
  end


  def ping do
    req= Proto.PingRequest.new(client_id: client_id)
          |> Proto.put_timestamp(:ping_timestamp)
          |> Proto.PingRequest.encode
    case resp= send_message("/ping", req) do
      {:ok, resp_body} ->
        {:ok, resp_body |> Proto.PongResponse.decode}
      _ ->
        {:error, resp}
    end
  end

  def client_id do
    Application.fetch_env!(:memento_client, :client_id)
  end

  def get_notes(page, _) when page <= 0, do: raise "Page should be >= 1"
  def get_notes(_, per_page) when per_page <= 0, do: "Per page parameter should be > 0"
  def get_notes(page, per_page) do
    req= Proto.NoteListRequest.new(
      client_id: client_id,
      page: page,
      page_size: per_page
    ) |> Proto.NoteListRequest.encode
    case resp= send_message("/notes", req) do
      {:ok, resp_body} ->
        {:ok, resp_body |> Proto.NoteListResponse.decode}
      _ ->
        {:error, resp}
    end
  end

  def get_note(note_id) do
    req= Proto.NoteGetRequest.new(
      client_id: client_id,
      note_id:   note_id
    ) |> Proto.NoteGetRequest.encode
    case resp= send_message("/notes/get", req) do
      {:ok, resp_body} ->
        {:ok, resp_body |> Proto.NoteGetResponse.decode |> Map.get(:note)}
      _ ->
        {:error, resp}
    end
  end

  def create_note(note= %Proto.Note{}) do
    data= Proto.NoteCreateRequest.new(note: note, client_id: client_id) 
      |> Proto.put_timestamp
      |> Proto.NoteCreateRequest.encode
    case resp= send_message("/notes/new", data) do
      {:ok, resp_body} ->
        {:ok, resp_body |> Proto.NoteCreateResponse.decode}
      _ ->
        {:error, resp}
    end
  end

  # private functions

  defp send_message(path, message) do
    resp= HTTPoison.post("#{server_url}#{path}", message)
    case resp do
      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:ok, body}
      _ ->
        {:error, resp}
    end
  end

end
