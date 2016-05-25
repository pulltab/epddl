
-record(var,
    {id :: binary(),
     type :: undefined | binary()
    }).

-record(predicate,
    {id :: binary(),
     vars = [] :: list(#var{})
    }).

-type bool_op() :: 'not'.
-type bool_multi_op() :: 'and' | 'or'.
-type bool_expr() :: true
                     | #predicate{}
                     | {bool_op(), bool_expr()}
                     | {bool_multi_op(), list(bool_expr())}.

-record(effect,
    {
     delta = true :: true
                     | #predicate{}
                     | {bool_op(), #predicate{}}
                     | {bool_multi_op(), list(#effect{})}
                     | list({float(), #effect{}}),
     time = undefined :: undefined | 'start' | 'end'
    }).
-type effect_expr() :: #effect{}.

-type number_expr() :: number().
-type duration_constraint_op() :: '=' | '<=' | '>='.
-type duration_constraint() :: {duration_constraint_op(), number_expr()}.

-record(action,
    {id :: undefined | binary(),
     parameters = [] :: list(binary()),
     duration :: undefined | duration_constraint(),
     precondition = true :: bool_expr(),
     effect = #effect{} :: effect_expr()
    }).

-record(domain,
    {id :: undefined | binary(),
     requirements = [] :: list(binary()),
     types = [] :: list(binary()),
     predicates = [] :: list(#predicate{}),
     actions = [] :: list(#action{})
    }).
