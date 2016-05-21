-module(probabilistic_test).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

prob_effect_requires_probabilistic_effects_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (probabilistic 0.5 ())))",
    Domain = epddl:parse(DomainStr),
    ?assert(Domain#domain.requirements == ["probabilistic-effects"]).
