-module(epddl).

-export([tokens/1,
         parse/1,
         parse_file/1
        ]).

tokens(String) when is_list(String) ->
    {ok, Tokens, _} = epddl_tokenizer:string(String),
    Tokens;
tokens(Binary) when is_binary(Binary) ->
    tokens(binary_to_list(Binary)).

parse(String) ->
    {ok, Tokens, _} = epddl_tokenizer:string(String),
    {ok, AST} = epddl_parser:parse(Tokens),
    AST.

parse_file(Filename) ->
	{ok, FileContents} = read_lines(Filename),
	parse(FileContents).
	
read_lines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try
		get_all_lines(Device)
    after
		file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.
