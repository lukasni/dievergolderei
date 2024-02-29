defmodule DievergoldereiWeb.UserConfirmationInstructionsLive do
  use DievergoldereiWeb, :live_view

  alias Dievergolderei.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
      Keine Aktivierungsanweisungen erhalten?
        <:subtitle>Wir senden dir einen neuen Aktivierungslink via E-Mail</:subtitle>
      </.header>

      <.simple_form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <.button phx-disable-with="Wird versandt..." class="w-full">
            Versenden
          </.button>
        </:actions>
      </.simple_form>

      <p class="text-center mt-4">
        <.link href={~p"/users/log_in"}>Anmelden</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "Wenn deine E-Mail in unserem System ist und noch nicht bestätigt wurde, wirst du in Kürze eine E-Mail mit Anweisungen erhalten."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
