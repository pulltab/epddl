defmodule EpddlDomainTest do
  use ExUnit.Case
  doctest EPDDL

  test "Empty Domain Definition" do
    simpleDomain = "(define (domain foo))"
    EPDDL.parse(simpleDomain)
  end

end
