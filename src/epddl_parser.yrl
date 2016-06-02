Nonterminals    definition
                domainExpr domainPropList domainProp
                typesExpr predicatesExpr
                predicate predicateDef predicateDefList
                actionDefList actionDef
                actionPropList actionProp
                effectExpr effectExprList
                probabilisticEffect probabilisticEffectList
                timeSpecifier durationConstraints durationConstraint durationConstraintOp
                varDef varDefList
                boolOp boolMultiOp boolExpr boolExprList
                id idList
                numberExpr
                type.

Terminals       '(' ')' '-' '=' '<' '>'
                and or not
                at start end
                define
                predicates
                parameters
                precondition
                types
                action
                effect
                domain
                probabilistic
                duration
                number
                name.

Rootsymbol definition.

definition ->
    '(' define domainExpr ')' : '$3'.

domainExpr ->
    '(' domain id ')' : to_domain('$3', []).
domainExpr ->
    '(' domain id ')' domainPropList : to_domain('$3', '$5').

domainProp ->
    typesExpr : {types, '$1'}.
domainProp ->
    predicatesExpr : {predicates, '$1'}.
domainProp ->
    actionDefList : {actions, '$1'}.

domainPropList ->
    domainProp : ['$1'].
domainPropList ->
    domainProp domainPropList : ['$1'|'$2'].

typesExpr ->
    '(' types idList ')' : require(typing), '$3'.

predicatesExpr ->
    '(' predicates predicateDefList ')' : '$3'.

predicateDef ->
    '(' id varDefList ')' : #predicate{id='$2', vars='$3'}.

predicateDefList ->
    predicateDef : ['$1'].
predicateDefList ->
    predicateDef predicateDefList : ['$1'|'$2'].

%% NOTE:  These two rules introduce a shift/reduce conflict.
varDef -> idList '-' type :
    require(typing),
    Type='$3',
    [#var{id=ID, type=Type} || ID <- '$1'].
varDef -> idList : [#var{id=ID} || ID <- '$1'].

varDefList ->
    varDef : '$1'.
varDefList ->
    varDef varDefList : lists:flatten(['$1'|'$2']).

id -> name : extract('$1').

idList ->
    id : ['$1'].
idList ->
    id idList : ['$1'|'$2'].

type -> name : extract('$1').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Actions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

actionDefList ->
    actionDef : ['$1'].
actionDefList ->
    actionDef actionDefList : ['$1'|'$2'].

actionDef ->
    '(' action id actionPropList ')' :
            PropsMap = maps:from_list('$4'),
            #action{id='$3',
                    parameters = maps:get(parameters, PropsMap, []),
                    precondition = maps:get(precondition, PropsMap, true),
                    effect = maps:get(effect, PropsMap, undefined),
                    duration = maps:get(duration, PropsMap, undefined)
                   }.

actionPropList ->
    actionProp : ['$1'].
actionPropList ->
    actionProp actionPropList : ['$1'|'$2'].

actionProp ->
    parameters '(' varDefList ')' : {parameters, '$3'}.
actionProp ->
    precondition boolExpr : {precondition, '$2'}.
actionProp ->
    effect effectExpr : {effect, '$2'}.
actionProp ->
    duration durationConstraints :
        require('durative-actions'),
        {duration, '$2'}.

timeSpecifier ->
    'start' : 'start'.
timeSpecifier ->
    'end'   : 'end'.

effectExpr ->
    '(' ')' : #effect{}.
effectExpr ->
    predicate : #effect{delta='$1'}.
effectExpr ->
    '(' boolOp  predicate ')' : #effect{delta={'$2', '$3'}}.
effectExpr ->
    '(' boolMultiOp effectExprList ')' : #effect{delta={'$2', '$3'}}.
effectExpr ->
    '(' probabilistic probabilisticEffectList ')' :
            require('probabilistic-effects'),
            ProbEffects = '$3',
            Sum = fun({Val, _}, Acc) -> Val + Acc end,
            Total = lists:foldl(Sum, 0, ProbEffects),
            NewProbEffects =
                if
                    Total > 1 ->
                        %% Constraint violation
                        error(bad_probabilistic);

                    Total < 1 ->
                        Diff = 1.0 - Total,
                        RoundedDiff = round(Diff * math:pow(10, 2)) / math:pow(10, 2),
                        [{RoundedDiff, #effect{delta=true}}|ProbEffects];

                    true ->
                        ProbEffects
                end,
            #effect{delta=NewProbEffects}.
effectExpr ->
    '(' 'at' timeSpecifier effectExpr ')' :
        Effect = '$4',
        Effect#effect{time = '$3'}.

effectExprList ->
    effectExpr : ['$1'].
effectExprList ->
    effectExpr effectExprList : ['$1'|'$2'].

probabilisticEffect ->
    number effectExpr : {extract('$1'), '$2'}.

probabilisticEffectList ->
    probabilisticEffect : ['$1'].
probabilisticEffectList ->
    probabilisticEffect probabilisticEffectList : ['$1'|'$2'].

durationConstraints ->
    '(' 'and' durationConstraint durationConstraints ')' : lists:flatten(['$3'|'$4']).
durationConstraints ->
    durationConstraint : ['$1'].

durationConstraint ->
    '(' ')' :
        undefined.
durationConstraint ->
    numberExpr :
        {'=', '$1'}.
durationConstraint ->
    '(' durationConstraintOp numberExpr ')' :
        {'$2', '$3'}.

durationConstraintOp ->
    '=' : '='.
durationConstraintOp ->
    '<' '=' :
        require('duration-inequalities'),
        '<='.
durationConstraintOp ->
    '>' '=' :
        require('duration-inequalities'),
        '>='.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bool Expressions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boolMultiOp -> and : 'and'.
boolMultiOp -> or : 'or'.

boolOp -> not : 'not'.

predicate ->
    '(' id idList ')' : {predicate, '$2', '$3'}.

boolExprList ->
    boolExpr : ['$1'].
boolExprList ->
    boolExpr boolExprList : ['$1'|'$2'].

boolExpr ->
    '(' ')' : true.
boolExpr ->
    predicate : '$1'.
boolExpr ->
    '(' boolMultiOp boolExprList ')' : {'$2', '$3'}.
boolExpr ->
    '(' boolOp boolExpr ')' : {'$2', '$3'}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Number Expressions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numberExpr ->
   number : extract('$1').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Erlang Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Erlang code.

-include("../include/epddl_types.hrl").

-define(REQUIREMENTS_TID, epddl_requirements).

extract({_, _, Value}) -> Value.

ensure_table(Tab) ->
    try
        ets:new(Tab, [named_table, private])
    catch
        _:_ ->
            Tab
    end.

tab2list(Tab) ->
    case ets:info(Tab) of
        undefined ->
            [];

        _ ->
            ets:tab2list(Tab)
    end.

require(Req) ->
    ensure_table(?REQUIREMENTS_TID),
    ets:insert(?REQUIREMENTS_TID, {atom_to_binary(Req, utf8), true}).

cleanup() ->
    try
        true = ets:delete(?REQUIREMENTS_TID)
    catch
        _:_ ->
            true
    end.

to_domain(ID, []) ->
    Domain = #domain{id=ID},
    cleanup(),
    Domain;
to_domain(ID, PropList) ->
    DomainMap = maps:from_list(PropList),
    Requirements = [Req || {Req, true} <- tab2list(?REQUIREMENTS_TID)],
    Domain =
        #domain{
            id = ID,
            requirements = Requirements,
            types = maps:get(types, DomainMap, []),
            predicates = maps:get(predicates, DomainMap, []),
            actions = maps:get(actions, DomainMap, [])
        },
    cleanup(),
    Domain.
