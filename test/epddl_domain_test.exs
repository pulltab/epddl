defmodule EpddlDomainTest do
  use ExUnit.Case
  doctest EPDDL

  require Record

  test "Empty Domain Definition" do
    simpleDomain = "(define (domain foo))"
    domainDef = EPDDL.parse(simpleDomain)
    assert(Record.is_record(domainDef, :domain))
    assert(EPDDL.domain(domainDef, :id) != :undefined)
    assert(EPDDL.domain(domainDef, :id) == "foo")
  end

  test "Predicates" do
    domainStr = "(define (domain foo) (:predicates (at ?v) (location ?v ?l)))"
    domainDef = EPDDL.parse(domainStr)
    assert(EPDDL.domain(domainDef, :requirements) == [])
    assert(length(EPDDL.domain(domainDef, :predicates)) == 2)

    # Ensure predicate records are defined to our satisfaction
    [at, location] = EPDDL.domain(domainDef, :predicates)
    assert(EPDDL.predicate(at, :id) == "at")
    assert(EPDDL.predicate(at, :vars) == [{:var, "v", :undefined}])

    assert(EPDDL.predicate(location, :id) == "location")
    assert(EPDDL.predicate(location, :vars) == [{:var, "v", :undefined},
                                                {:var, "l", :undefined}])
  end

end
