
-record(domain,
    {id = undefined,
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
     vars=[]
    }).
