defmodule ScroogeWeb.UserRegistrationLive do
  use ScroogeWeb, :live_view

  alias Scrooge.Accounts
  alias Scrooge.Accounts.User

  def render(assigns) do
    ~H"""
    <main class="flex min-h-screen flex-col justify-center">
      <.header class="text-center px-4">
        Join Scrooge
        <:subtitle>
          Already have an account?
          <.link navigate={~p"/sign-in"} class="text-sky-600 hover:underline">Sign in</.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        :let={f}
        id="registration_form"
        for={@changeset}
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/sign-in?_action=registered"}
        method="post"
        as={:user}
      >
        <.error
          :if={@changeset.action == :insert}
          message="Oops, something went wrong! Please check the errors below."
        />

        <.input field={{f, :email}} type="email" label="Email" required />
        <.input
          field={{f, :password}}
          type="password"
          label="Password"
          value={input_value(f, :password)}
          required
        />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    socket = assign(socket, changeset: changeset, trigger_submit: false)
    {:ok, socket, layout: false, temporary_assigns: [changeset: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/settings/confirm-account/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, assign(socket, trigger_submit: true, changeset: changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign(socket, changeset: Map.put(changeset, :action, :validate))}
  end
end
