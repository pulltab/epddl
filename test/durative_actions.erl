-module(durative_actions).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

simple_durative_action_equal_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (= ?duration 10) :effect ()))",
    Domain = epddl:parse(DomainStr),

    [<<"durative-actions">>] = Domain#domain.requirements,
        
    [Bar] = Domain#domain.actions,
    [{'=', 10}] = Bar#action.duration.

simple_durative_action_gte_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (>= ?duration 101.103) :effect ()))",
    Domain = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    [{'>=', 101.103}] = Bar#action.duration.

simple_durative_action_lte_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (<= ?duration 300) :effect ()))",
    Domain = epddl:parse(DomainStr),

    ?assert(lists:member(<<"duration-inequalities">>, Domain#domain.requirements)),

    [Bar] = Domain#domain.actions,
    [{'<=', 300}] = Bar#action.duration.

multi_constraint_durative_action_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (and (<= ?duration 300) (>= ?duration 250)) :effect ()))",
    Domain = epddl:parse(DomainStr),

    ?assert(lists:member(<<"duration-inequalities">>, Domain#domain.requirements)),

    [Bar] = Domain#domain.actions,
    [{'<=', 300}, {'>=', 250}] = Bar#action.duration.
