defmodule DievergoldereiWeb.UserLoginLive do
  use DievergoldereiWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm bg-white p-6 rounded">
      <.header class="text-center">
        Anmelden
        <:subtitle>
          Zugang zum Adminbereich ist nur für registrierte Benutzer verfügbar
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Passwort" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Eingeloggt bleiben" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Passwort vergessen?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="In Arbeit..." class="w-full button-dvblue">
            Anmelden <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
