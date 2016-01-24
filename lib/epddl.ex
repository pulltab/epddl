defmodule EPDDL do

  def tokens(toTokenize) do
    {:ok, tokens, _} = toTokenize |> to_char_list |> :pddl.string
    tokens
  end

  @spec parse(binary) :: term
  def parse(toParse) do
    {:ok, tokens, _} = toParse |> to_char_list |> :pddl.string
    {:ok, ast} = :pddl_parser.parse(tokens)
    ast
  end

  @spec parse_file(binary) :: term
  def parse_file(filename) do
    {:ok, fileContents} = File.read(filename)
    parse(fileContents)
  end

end
