
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
                     {bool_multi_op(), list(bool_expr())}.

-record(action,
    {id :: undefined | binary(),
     parameters = [] :: list(binary()),
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
