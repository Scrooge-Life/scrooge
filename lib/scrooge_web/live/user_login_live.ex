defmodule ScroogeWeb.UserLoginLive do
  use ScroogeWeb, :live_view

  def render(assigns) do
    ~H"""
    <main class="flex min-h-screen flex-col justify-center">
      <.header class="text-center px-4">
        Sign in to Scrooge
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/join"} class="text-sky-600 hover:underline">Join Scrooge</.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form
        :let={f}
        id="login_form"
        for={:user}
        action={~p"/sign-in"}
        as={:user}
        phx-update="ignore"
      >
        <.input field={{f, :email}} type="email" label="Email" required />
        <.input field={{f, :password}} type="password" label="Password" required />

        <:actions :let={f}>
          <.input field={{f, :remember_me}} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/reset-password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Sigining in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, email: email), layout: false, temporary_assigns: [email: nil]}
  end
end
