-module(epddl_requirements_typing_test).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

types_forces_typing_requirement_test() ->
    DomainStr = "(define (domain foo) (:types bar))",
    Domain = epddl:parse(DomainStr),
    Domain#domain.requirements == ["typing"].

typed_vars_forces_typing_requirement_test() ->
    DomainStr = "(define (domain foo) (:predicates (bar ?v - vehicle)))",
    Domain = epddl:parse(DomainStr),
    Domain#domain.requirements == ["typing"].

types_and_typed_vars_forces_typing_requirement_test() ->
    DomainStr = "(define (domain foo) (:types vehicle) (:predicates (bar ?v - vehicle)))",
    Domain = epddl:parse(DomainStr),
    Domain#domain.requirements == ["typing"].
