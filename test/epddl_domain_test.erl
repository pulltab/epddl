-module(epddl_domain_test).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

empty_domain_test() ->
    SimpleDomain = "(define (domain foo))",
    DomainDef = epddl:parse(SimpleDomain),
    ?assert(is_record(DomainDef, domain)),
    ?assert(DomainDef#domain.id /= undefined),
    ?assert(DomainDef#domain.id == <<"foo">>).

simple_action_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect()))",
    Domain = epddl:parse(DomainStr),

    ?assert(length(Domain#domain.actions) == 1),
    [Bar] = Domain#domain.actions,
    ?assert(is_record(Bar, action)),

    ?assert(Bar#action.id == <<"bar">>),
    ?assert(Bar#action.parameters == []),
    ?assert(Bar#action.precondition == true),
    ?assert(Bar#action.effect == true).

action_effect_test() ->
    DomainStr = "(define (domain foo) (:action bar :effect (and (at ?v) (at ?b) (not (loc ?c ?d)))))",
    Domain = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    ?assert(Bar#action.effect /= undefined),
    {'and', [At1, At2, NotExpr]} = Bar#action.effect,
    
    {predicate, <<"at">>, [<<"v">>]} = At1,
    {predicate, <<"at">>, [<<"b">>]} = At2,
    {'not', Loc} = NotExpr,
    {predicate, <<"loc">>, [<<"c">>, <<"d">>]} = Loc.

