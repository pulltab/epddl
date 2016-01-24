Nonterminals domainExpr predicatesExpr predicate predicateList
varList var id type.
Terminals '(' ')' '?' '-' 'define' 'predicates' 'domain' name.

Rootsymbol domainExpr.

domainExpr ->
    '(' define '(' domain id ')' predicatesExpr ')' : {domain, '$5', '$7'}.

predicatesExpr -> 
    '(' predicates predicateList ')' : '$3'.
 
predicateList ->
    predicate : ['$1'].
predicateList ->
    predicate predicateList : ['$1'|'$2'].

predicate ->
    '(' id varList ')' : {predicate, '$2', '$3'}.

var -> '?' id '-' type : {variable, extract('$2'), extract('$4')}.

id -> name : extract('$1').

type -> name : extract('$1').

varList -> 
    var : ['$1'].
varList ->
    var varList : ['$1'|'$2'].

Erlang code.

extract({_, _, Value}) -> Value.
