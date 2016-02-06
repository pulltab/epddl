Nonterminals    definition
                domainExpr
                typesExpr
                predicatesExpr
                predicate predicateDef predicateDefList
                actionDefList actionDef actionParameters
                actionPreconditions actionEffects actionEffect
                actionEffectExprList actionEffectExpr
                varDef varDefList
                boolOp boolMultiOp boolExpr boolExprList
                id idList
                type.

Terminals       '(' ')' '-'
                and or not
                define
                predicates
                preconditions
                types
                action
                effects
                domain
                name
                identifier.

Rootsymbol definition.

definition ->
    '(' define domainExpr ')' : {definition, '$3'}.

domainExpr ->
    '(' domain id ')' typesExpr predicatesExpr actionDefList : {domain, '$3', '$5', '$6', '$7'}.

typesExpr ->
    '(' types idList ')' : '$3'.

predicatesExpr ->
    '(' predicates predicateDefList ')' : '$3'.

predicateDef ->
    '(' id varDefList ')' : {predicate, '$2', '$3'}.

predicateDefList ->
    predicateDef : ['$1'].
predicateDefList ->
    predicateDef predicateDefList : ['$1'|'$2'].

varDef -> idList '-' type : Type='$3', [{variable, ID, Type} || ID <- '$1'].

varDefList ->
    varDef : ['$1'].
varDefList ->
    varDef varDefList : ['$1'|'$2'].

id -> name : extract('$1').

idList ->
    id : ['$1'].
idList ->
    id idList : ['$1'|'$2'].

type -> name : extract('$1').


actionDefList ->
    actionDef : ['$1'].
actionDefList ->
    actionDef actionDefList : ['$1'|'$2'].

actionDef ->
    '(' action id actionParameters actionPreconditions actionEffects ')' : {action, '$3', '$4', '$5'}. 

actionParameters ->
    varDefList : '$1'.

actionPreconditions ->
    preconditions boolExpr : {preconditions, '$2'}.

actionEffects ->
   effects actionEffect : {effect, '$2'}.

actionEffect ->
   '(' ')' : undefined.
actionEffect -> 
   actionEffectExpr : '$1'.

actionEffectExpr ->
   predicate : '$1'.
actionEffectExpr ->
   '(' not predicate ')' : {'not', '$3'}.
actionEffectExpr ->
   '(' and actionEffectExprList ')'.
   
actionEffectExprList ->
    actionEffectExpr : '$1'.
actionEffectExprList ->
    actionEffectExpr actionEffectExprList : ['$1'|'$2'].

boolMultiOp -> and : 'and'.
boolMultiOp -> or : 'or'.

boolOp -> not : 'not'.

predicate ->
    '(' id idList ')' : {predicate, '$2', '$3'}.

boolExprList ->
    boolExpr : '$1'.
boolExprList ->
    boolExpr boolExprList : ['$1'|'$2'].

boolExpr ->
    predicate : '$1'.
boolExpr ->
    '(' boolMultiOp boolExprList ')' : {'$2', '$3'}.
boolExpr ->
    '(' boolOp boolExpr ')' : {'$2', '$3'}.


Erlang code.

extract({_, _, Value}) -> Value.
