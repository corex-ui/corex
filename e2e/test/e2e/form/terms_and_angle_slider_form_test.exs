defmodule E2e.Form.TermsAndAngleSliderFormTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias E2e.Form.AngleSliderForm
  alias E2e.Form.Terms

  test "Terms changeset rejects unchecked state" do
    assert %{valid?: false} = Terms.changeset(%Terms{}, %{"terms" => "false"})
  end

  test "Terms changeset_validate uses custom acceptance message" do
    cs = Terms.changeset_validate(%Terms{}, %{"terms" => "false"})
    assert %{valid?: false} = cs
    assert [{msg, _} | _] = Keyword.get_values(cs.errors, :terms)
    assert msg == "must be accepted to continue"
  end

  test "to_form for Terms exposes nested name and id for checkbox field" do
    cs = Terms.changeset(%Terms{}, %{})
    f = to_form(cs, as: :terms, id: "checkbox-live-form")
    assert f[:terms].name == "terms[terms]"
    assert f[:terms].id == "checkbox-live-form_terms"
  end

  test "AngleSliderForm changeset_validate rejects angle above 90" do
    cs = AngleSliderForm.changeset_validate(%AngleSliderForm{}, %{"angle" => "150"})
    assert %{valid?: false} = cs
    assert [{msg, _} | _] = Keyword.get_values(cs.errors, :angle)
    assert msg == "must be between 0 and 90"
  end

  test "to_form for AngleSliderForm validate branch exposes angle name" do
    cs = AngleSliderForm.changeset_validate(%AngleSliderForm{}, %{})
    f = to_form(cs, as: :angle_slider_validate, id: "angle-slider-validate-form-live")
    assert f[:angle].name == "angle_slider_validate[angle]"
    assert f[:angle].id == "angle-slider-validate-form-live_angle"
  end
end
