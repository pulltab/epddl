defmodule EpddleRequirementsProbabilisticEffectsTest do

  use ExUnit.Case
  doctest EPDDL

  require Record

  test "" do
    domainStr = "(define (domain foo) (:action bar :effect (probabilistic 0.5 ())))"
    domainDef = EPDDL.parse(domainStr)
    assert(EPDDL.domain(domainDef, :requirements) == ["probabilistic-effects"])
  end

end
