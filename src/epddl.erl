-module(epddl).

-export([tokens/1,
         parse/1,
         parse_file/1
        ]).

%%%===================================================================
%%% API
%%%===================================================================

tokens(String) when is_list(String) ->
    {ok, Tokens, _} = epddl_tokenizer:string(String),
    Tokens;
tokens(Binary) when is_binary(Binary) ->
    tokens(binary_to_list(Binary)).

parse(String) ->
    {ok, Tokens, _} = epddl_tokenizer:string(String),
    Self = self(),

    %% Parsing requires use of global state (ETS).
    %% As such, we parse within a separate thread to
    %% ensure this global state is cleaned up properly.
    ParseFN =
        fun()->
            Res =
                try
                    epddl_parser:parse(Tokens)
                catch
                    _:Reason ->
                        {error, Reason}
                end,
            Self ! {'$epddl_parse', Res}
        end,
    Pid = spawn(ParseFN),
    Ref = erlang:monitor(process, Pid),

    receive
        {'$epddl_parse', {ok, Res}} ->
            Res;

        {'$epddl_parse', {error, Error}} ->
            error(Error);
    
        {_, Ref, process, _, Info} ->
            error({parsing_failed, Info})
    end.

parse_file(Filename) ->
	{ok, FileContents} = read_lines(Filename),
	parse(FileContents).

%%%===================================================================
%%% Internal Functions
%%%===================================================================

read_lines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try
		get_all_lines(Device)
    after
		file:close(Device)
    end.

get_all_lines(Device) ->
    Lines = case io:get_line(Device, "") of
                eof  -> [];
                Line -> Line ++ get_all_lines(Device)
            end,
    {ok, Lines}.
