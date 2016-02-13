
-record(domain,
    {id = undefined,
     requirements = [],
     types = [],
     predicates = [],
     actions = []
    }).

-record(action,
    {id,
     parameters = [],
     precondition = true,
     effect
    }).

-record(predicate,
    {id,
     vars = []
    }).

-record(var,
    {id,
     type
    }).
