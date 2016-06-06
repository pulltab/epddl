-module(external_effects).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

string_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (post \"\" \"\" \"\" )))",
    Domain = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    Effect = Bar#action.effect,
    ?assert(is_record(Effect, effect)),

    Delta = Effect#effect.delta,
    ?assert(is_record(Delta, external_effect)),
    ?assertMatch(<<"post">>, Delta#external_effect.method),
    ?assertMatch(<<"">>, Delta#external_effect.url),
    ?assertMatch(<<"">>, Delta#external_effect.headers),
    ?assertMatch(<<"">>, Delta#external_effect.body).

string_template_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (post (\"http://www.google.com/{}/{}/{}\" ?x ?y ?z) ( \"\" ?a ?b) (\"\"))))",
    Domain = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    Effect = Bar#action.effect,
    ?assert(is_record(Effect, effect)),

    Delta = Effect#effect.delta,
    ?assert(is_record(Delta, external_effect)),
    ?assertMatch(<<"post">>, Delta#external_effect.method),
    ?assertMatch({<<"http://www.google.com/{}/{}/{}">>, [<<"x">>, <<"y">>, <<"z">>]}, Delta#external_effect.url),
    ?assertMatch({<<"">>, [<<"a">>, <<"b">>]}, Delta#external_effect.headers),
    ?assertMatch(<<"">>, Delta#external_effect.body).

valid_method_test() ->
    Methods = [<<"post">>, <<"put">>, <<"get">>, <<"patch">>, <<"delete">>],

    [begin
        DomainStr = lists:flatten(io_lib:format("(define (domain foo) (:action bar :effect (~s () () ())))", [Method])),
        Domain = epddl:parse(DomainStr),

        ?assertMatch([<<"external-effects">>], Domain#domain.requirements),

        [Bar] = Domain#domain.actions,

        Effect = Bar#action.effect,
        ?assertNotMatch(undefined, Effect),
        ?assert(is_record(Effect, effect)),

        Delta = Effect#effect.delta,
        ?assert(is_record(Delta, external_effect)),
        ?assertMatch(Method, Delta#external_effect.method),
        ?assertMatch(<<"">>, Delta#external_effect.url),
        ?assertMatch(<<"">>, Delta#external_effect.headers),
        ?assertMatch(<<"">>, Delta#external_effect.body)
     end || Method <- Methods].

invalid_method_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (badmethod () () ())))",
    Good=
        try
          _Domain = epddl:parse(DomainStr),
          false %% <--- Should not be reached
        catch
          _:_ ->
            true
        end,
    ?assert(Good).
