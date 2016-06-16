-module(durative_actions).

-include("../include/epddl_types.hrl").

-include_lib("eunit/include/eunit.hrl").

durative_action_equal_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (= 10) :effect ()))",
    {ok, Domain} = epddl:parse(DomainStr),

    [<<"durative-actions">>] = Domain#domain.requirements,
        
    [Bar] = Domain#domain.actions,
    [{'=', 10}] = Bar#action.duration.

durative_action_literal_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration 101 :effect ()))",
    {ok, Domain} = epddl:parse(DomainStr),

    [<<"durative-actions">>] = Domain#domain.requirements,
    [Bar] = Domain#domain.actions,
    [{'=', 101}] = Bar#action.duration.

durative_action_gte_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (>= 101.103) :effect ()))",
    {ok, Domain} = epddl:parse(DomainStr),

    ?assert(lists:member(<<"duration-inequalities">>, Domain#domain.requirements)),

    [Bar] = Domain#domain.actions,
    [{'>=', 101.103}] = Bar#action.duration.

durative_action_lte_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (<= 300) :effect ()))",
    {ok, Domain} = epddl:parse(DomainStr),

    ?assert(lists:member(<<"duration-inequalities">>, Domain#domain.requirements)),

    [Bar] = Domain#domain.actions,
    [{'<=', 300}] = Bar#action.duration.

multi_constraint_durative_action_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (and (<= 300) (>= 250)) :effect ()))",
    {ok, Domain} = epddl:parse(DomainStr),

    ?assert(lists:member(<<"duration-inequalities">>, Domain#domain.requirements)),

    [Bar] = Domain#domain.actions,
    [{'<=', 300}, {'>=', 250}] = Bar#action.duration.

duration_var_in_constraint_results_in_error_test() ->
    DomainStr ="(define (domain foo) (:action bar :duration (<= ?duration 300))",
    try
        epddl:parse(DomainStr),
        ?assert(false) %% <--- Should not be reached
    catch
        _:_ ->
            ?assert(true)
    end.

start_effect_test() ->
    DomainStr = "(define (domain foo) (:action bar :duration (<= 300) :effect (at start ())))",
    {ok, Domain} = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    Effect = Bar#action.effect,
    ?assertMatch(#effect{delta=true, time=start}, Effect).

stop_effect_test() ->
    DomainStr = "(define (domain foo) (:action bar :duration (<= 300) :effect (at end ())))",
    {ok, Domain} = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    Effect = Bar#action.effect,
    ?assertMatch(#effect{delta=true, time='end'}, Effect).

nested_durative_effect_test() ->
    DomainStr = "(define (domain foo) (:action bar :duration (<= 300) :effect (and (at end ()) (at start ()))))",
    {ok, Domain} = epddl:parse(DomainStr),

    [Bar] = Domain#domain.actions,
    Effect = Bar#action.effect,
    End = #effect{delta=true, time='end'},
    Start = #effect{delta=true, time='start'},

    ?assertMatch(#effect{delta={'and', [End, Start]}}, Effect).
