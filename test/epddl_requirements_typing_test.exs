defmodule EpddleRequirementsTypingTest do

  use ExUnit.Case
  doctest EPDDL

  require Record

  test "Types property implies typing requirement" do
    domainStr = "(define (domain foo) (:types bar))"
    domainDef = EPDDL.parse(domainStr)
    assert(EPDDL.domain(domainDef, :requirements) == ["typing"])
  end

  test "Typed vars imply typing requirement" do
    domainStr = "(define (domain foo) (:predicates (at ?v - vehicle)))"
    domainDef = EPDDL.parse(domainStr)
    assert(EPDDL.domain(domainDef, :requirements) == ["typing"])
  end

  test "Types and Typed vars imply typing requirement" do
    domainStr = "(define (domain foo) (:types vehicle) (:predicates (at ?v - vehicle)))"
    domainDef = EPDDL.parse(domainStr)
    assert(EPDDL.domain(domainDef, :requirements) == ["typing"])
  end

end
