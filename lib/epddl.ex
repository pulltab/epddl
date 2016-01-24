defmodule EPDDL do

  @spec parse(binary) :: term
  def parse(toParse) do
    {:ok, tokens} = toParse |> to_char_list |> :pddl.string
    {:ok, ast} = :ppdl_parser.parse(tokens)
    ast
  end

end
