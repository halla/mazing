defmodule Mazing.Cli do
  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    case parse do
      {[help: true], _argv, _errors} ->
        :help

      _ ->
        :help
    end
  end

  def process(:help) do
    IO.puts("""
      Some helpful message here
    """)
  end
end
