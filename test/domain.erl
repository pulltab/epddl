-module(domain).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

empty_domain_test() ->
    SimpleDomain = "(define (domain foo))",
    {ok, DomainDef} = epddl:parse(SimpleDomain),
    ?assert(is_record(DomainDef, domain)),
    ?assert(DomainDef#domain.id /= undefined),
    ?assert(DomainDef#domain.id == <<"foo">>).

simple_action_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect ()))",
    {ok, Domain} = epddl:parse(DomainStr),

    ?assert(length(Domain#domain.actions) == 1),
    [Bar] = Domain#domain.actions,
    ?assert(is_record(Bar, action)),

    ?assert(Bar#action.id == <<"bar">>),
    ?assert(Bar#action.parameters == []),
    ?assert(Bar#action.precondition == true),
    ?assert(Bar#action.effect == #effect{delta=true}).

action_effect_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (and (loc ?v) (loc ?b) (not (loc ?c ?d)))))",
    {ok, Domain} = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    ?assert(Bar#action.effect /= undefined),

    BarEffect = Bar#action.effect,
    ?assert(is_record(BarEffect, effect)),
    #effect{delta={'and', [Loc1, Loc2, NotExpr]}} = BarEffect,

    #effect{delta={predicate, <<"loc">>, [<<"v">>]}} = Loc1,
    #effect{delta={predicate, <<"loc">>, [<<"b">>]}} = Loc2,
    #effect{delta={'not', Loc}} = NotExpr,
    {predicate, <<"loc">>, [<<"c">>, <<"d">>]} = Loc.

action_parameters_test() ->
    DomainStr = "(define (domain foo) (:action bar :parameters (?a ?b ?c)))",
    {ok, Domain} = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,

    A = {var, <<"a">>, undefined},
    B = {var, <<"b">>, undefined},
    C = {var, <<"c">>, undefined},
    ?assert(Bar#action.parameters == [A, B, C]).

simple_action_precondition_test() ->
    DomainStr = "(define (domain foo) (:action bar :precondition (and (loc ?x ?y) (isCar ?y))))",
    {ok, Domain} = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    {'and', [Loc, IsCar]} = Bar#action.precondition,
    {predicate, <<"loc">>, [<<"x">>, <<"y">>]} = Loc,
    {predicate, <<"isCar">>, [<<"y">>]} = IsCar.

parameters_test() ->
    DomainStr = "(define (domain foo) (:parameters ?host ?port) (:action bar :precondition (and (loc ?x ?y) (isCar ?y))))",
    {ok, Domain} = epddl:parse(DomainStr),

    ?assertMatch([<<"parameterized-domains">>], Domain#domain.requirements),

    Params = Domain#domain.parameters,
    ?assert(is_list(Params)),
    ?assert(length(Params) == 2),
    ?assertMatch([], [<<"host">>, <<"port">>] -- Params).
