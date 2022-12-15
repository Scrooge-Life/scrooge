defmodule Scrooge.Mailer do
  @moduledoc """
  A `Swoosh.Mailer` instance for sending emails.
  """

  use Swoosh.Mailer, otp_app: :scrooge
end
