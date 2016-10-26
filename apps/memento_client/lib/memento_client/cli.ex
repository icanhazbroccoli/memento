defmodule MementoClient.CLI do

  alias MementoServer.Proto
  alias MementoClient.Server

  def parse_args(argv) do
    {parsed, args, _invalid}= argv
      |> OptionParser.parse(
        switcehs: [
          from: :string,
          page: :integer,
          per_page: :integer,
        ]
      )
    {parsed, args}
  end

  def proceed({opts, ["list" | _tail]}) do
    page= Keyword.get(opts, :page, 1)
    per_page= Keyword.get(opts, :per_page, 20)
    case Server.is_running? do
      false -> raise "Server seems to be down."
      true  ->
        {:ok, resp}= Server.get_notes(page, per_page)
        resp.notes
          |> Enum.map(fn note ->
            "* #{short_id note.uuid}\t#{short_note(note)}"
          end)
          |> Enum.join("\n")
          |> IO.puts
    end
  end

  def proceed({opts, ["get", note_id | _tail]}) do
    case Server.is_running? do
      false -> raise "Server seems to be down."
      true ->
        {:ok, note}= Server.get_note(note_id)
        time= note.timestamp
                |> :calendar.gregorian_seconds_to_datetime
                |> inspect
        IO.puts "Note: #{note.uuid}"
        IO.puts "Created: #{time}"
        IO.puts "\n#{note.body}\n"
    end
  end

  def proceed({opts, []}) do
    {from, opts}= Keyword.pop(opts, :from)
    stream= case from do
      nil ->
        IO.stream(:stdio, :line)
      from ->
        File.stream!(from, [], :line)
    end

    body= stream |> Enum.reduce(fn(line, acc) -> acc <> line end)

    note= Proto.Note.new(body: body)
      |> Proto.put_uuid
      |> Proto.put_timestamp

    case Server.is_running? do
      false -> raise "Server seems to be down."
      true  ->
        {:ok, resp}= Server.create_note(note)
        IO.puts "A new note with id #{short_id resp.note_id} was created"
    end
  end

  def short_id(id), do: id |> String.slice(0..6)
  def short_note(note) do
    note.body
      |> String.split("\n", parts: 2)
      |> List.first
      |> String.slice(0..30)
  end

end
