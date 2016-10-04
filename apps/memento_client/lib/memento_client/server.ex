defmodule MementoClient.Server do

  alias MementoClient.Proto

  @socket_path "/tmp/memento.sock"
  @server_url  "http://127.0.0.1:9876/proto"
  
  def is_running? do
    #TODO: this works only if the server and
    # the client are at the same machine.
    # Should use ping instead for remote
    # services.
    File.exists?(@socket_path)
  end

  def ping(cb) do
    send_message(Proto.Ping.new(), cb)
  end

  def send_data(data, cb) do
    send_message(data, cb)
  end

  # private functions

  defp send_message(message, cb) do
    resp= HTTPoison.post(@server_url, :erlang.term_to_binary(message))
    case resp do
      %HTTPoison.Response{status_code: status, body: body} ->
        # success!
        cb.({:ok, :erlang.binary_to_term(body)})
      _ ->
        #too bad
        cb.({:error, resp})
    end
  end

end
