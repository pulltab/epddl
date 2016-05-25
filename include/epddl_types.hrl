
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
-type bool_expr() :: #predicate{} |
                     {bool_op(), bool_expr()} |
                     {bool_multi_op(), list(bool_expr())} |
                     {probabilistic, list({float(), bool_expr()})}.

-type number_expr() :: number().
-type duration_constraint_op() :: '=' | '<=' | '>='.
-type duration_constraint() :: {duration_constraint_op(), number_expr()}.

-record(action,
    {id :: undefined | binary(),
     parameters = [] :: list(binary()),
     duration :: undefined | duration_constraint(),
     precondition = true :: boolean() | list(bool_expr()),
     effect = [] :: list(bool_expr())
    }).

-record(domain,
    {id :: undefined | binary(),
     requirements = [] :: list(binary()),
     types = [] :: list(binary()),
     predicates = [] :: list(#predicate{}),
     actions = [] :: list(#action{})
    }).
