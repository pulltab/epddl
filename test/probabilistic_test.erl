-module(probabilistic_test).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

prob_effect_requires_probabilistic_effects_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (probabilistic 1.0 ())))",
    Domain = epddl:parse(DomainStr),
    [<<"probabilistic-effects">>] = Domain#domain.requirements.

prob_effect_sum_less_than_1_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (probabilistic 0.40 () 0.37 ())))",
    Domain = epddl:parse(DomainStr),
    [Bar] = Domain#domain.actions,
   
    {probabilistic, Effect} = Bar#action.effect,
    ?assert(is_list(Effect)),

    %% Parsing should append an empty effect such that
    %% the probabilities all sum to 1.0. 
    ?assert(3 == length(Effect)),
    [] = [{0.23, true}, {0.40, true}, {0.37, true}] -- Effect.

prob_effect_sum_greater_than_1_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (probabilistic 0.75 () 1.0 ())))",
    try
        epddl:parse(DomainStr),
        ?assert(false) %% <-- Should not be reached
    catch
        _:_ ->
            ?assert(true)
    end.
