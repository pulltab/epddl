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

  test "Simple Action" do
    domainStr = "(define (domain foo) (:action bar :effect()))"
    domain = EPDDL.parse(domainStr)

    assert(length(EPDDL.domain(domain, :actions)) == 1)
    [bar] = EPDDL.domain(domain, :actions)
    assert(EPDDL.action(bar, :id) == "bar")
    assert(EPDDL.action(bar, :parameters) == [])
    assert(EPDDL.action(bar, :precondition) == true)
    assert(EPDDL.action(bar, :effect) == true)
  end

  test "Action Effects" do
    domainStr = "(define (domain foo) (:action bar :effect (and (at ?v) (at
  ?b) (not (loc ?c ?d)))))"
    domain = EPDDL.parse(domainStr)

    [bar] = EPDDL.domain(domain, :actions)

    assert(EPDDL.action(bar, :effect) != :undefined)

    {:and, [at1, at2, notExpr]} = EPDDL.action(bar, :effect)
    {:predicate, "at", ["v"]} = at1
    {:predicate, "at", ["b"]} = at2

    {:not, loc} = notExpr
    {:predicate, "loc", ["c", "d"]} = loc
  end
end
