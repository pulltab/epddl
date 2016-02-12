
-record(domain,
    {id = undefined,
     requirements = [],
     types = [],
     predicates = [],
     actions = []
    }).

-record(action,
    {id,
     parameters,
     preconditions,
     effects
    }).

-record(predicate,
    {id,
     vars = []
    }).

-record(var,
    {id,
     type
    }).
