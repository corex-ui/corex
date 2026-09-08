defmodule CorexAdmin.PolicyTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.Policy
  alias CorexAdmin.Test.DenyPolicy
  alias CorexAdmin.Test.Policy, as: AllowPolicy
  alias CorexAdmin.Test.TicketResource

  test "allows admin actors" do
    assert Policy.authorize(AllowPolicy, %{role: :admin}, :index, TicketResource, nil) == :ok
  end

  test "denies everyone else" do
    assert Policy.authorize(AllowPolicy, %{role: :viewer}, :index, TicketResource, nil) ==
             {:error, :unauthorized}

    assert Policy.authorize(AllowPolicy, nil, :index, TicketResource, nil) ==
             {:error, :unauthorized}
  end

  test "deny-all policy never allows" do
    assert Policy.authorize(DenyPolicy, %{role: :admin}, :index, TicketResource, nil) ==
             {:error, :unauthorized}
  end

  test "authorize_field defaults to :ok when not implemented" do
    assert Policy.authorize_field(
             AllowPolicy,
             %{role: :admin},
             :show,
             TicketResource,
             nil,
             :title
           ) == :ok
  end
end
