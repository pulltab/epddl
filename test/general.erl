-module(general).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

%% Asserts that parsing does not pollute local context
parse_cleanup_test() ->
    Before = ets:all(),
    DomainStr = "(define (domain foo))",
    epddl:parse(DomainStr),
    ?assertMatch(Before, ets:all()).
