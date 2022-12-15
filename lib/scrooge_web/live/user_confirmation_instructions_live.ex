defmodule ScroogeWeb.UserConfirmationInstructionsLive do
  use ScroogeWeb, :live_view

  alias Scrooge.Accounts

  def render(assigns) do
    ~H"""
    <main class="flex min-h-screen flex-col justify-center">
      <.header class="text-center px-4">
        Resend confirmation instructions
      </.header>

      <.simple_form :let={f} for={:user} id="resend_confirmation_form" phx-submit="send_instructions">
        <.input field={{f, :email}} type="email" label="Email" required />

        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            Resend confirmation instructions
          </.button>
        </:actions>
      </.simple_form>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/settings/confirm-account/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
