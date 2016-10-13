defmodule MementoClient.Server do

  alias MementoServer.Proto

  @server_url  "http://127.0.0.1:9876"
  
  def is_running? do
    #TODO: this works only if the server and
    # the client are at the same machine.
    # Should use ping instead for remote
    # services.
    # File.exists?(@lock_path)
    true
  end

  def ping(cb) do
    req= Proto.PingRequest.new()
          |> Proto.put_timestamp(:ping_timestamp)
          |> Proto.PingRequest.encode
    send_message("/ping", req, fn resp ->
      case resp do
        {:ok, resp_body} ->
          cb.(resp_body |> Proto.PongResponse.decode)
        {:error, _} -> cb.(resp)
      end
    end)
  end

  def create_note(note= %Proto.Note{}, cb) do
    data= Proto.NoteCreateRequest.new(
      note: note
    ) |> Proto.put_timestamp
      |> Proto.NoteCreateRequest.encode
    send_message("/notes/new", data, fn resp ->
      case resp do
        {:ok, resp_body} ->
          cb.({:ok, resp_body |> Proto.NoteCreateResponse.decode})
        {:error, _} -> cb.(resp)
      end
    end)
  end

  # private functions

  defp send_message(path, message, cb) do
    resp= HTTPoison.post("#{@server_url}#{path}", message)
    case resp do
      %HTTPoison.Response{status_code: status, body: body} ->
        # success!
        cb.({:ok, body})
      _ ->
        #too bad
        cb.({:error, resp})
    end
  end

end
