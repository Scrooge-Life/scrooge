defmodule ScroogeWeb.ErrorHTML do
  @moduledoc """
  Controller for handling and returning errors with HTML.
  """

  use ScroogeWeb, :html

  embed_templates "error_html/*"

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
