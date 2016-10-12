defmodule MementoClient.Server do

  alias MementoClient.Proto

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
    send_message(Proto.PingRequest.new(), cb)
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
