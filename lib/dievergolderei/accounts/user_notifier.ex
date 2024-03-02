defmodule Dievergolderei.Accounts.UserNotifier do
  import Swoosh.Email

  alias Dievergolderei.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Die Vergolderei", "noreply@mg.dievergolderei.ch"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Kontobestätigung", """

    ==============================

    Hi #{user.display_name},

    Du kannst dein Konto bestätigen,
    indem du die untenstehende URL besuchst:

    #{url}

    Falls du kein Konto bei uns erstellt hast,
    ignoriere diese Nachricht bitte.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Passwort zurücksetzen", """

    ==============================

    Hallo #{user.display_name},

    Du kannst dein Passwort zurücksetzen,
    indem du die untenstehende URL besuchst:

    #{url}

    Falls du diese Änderung nicht beantragt hast,
    ignoriere diese Nachricht bitte.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "E-Mail Änderung", """

    ==============================

    Hallo #{user.display_name},

    Du kannst Deine E-Mail Adresse ändern,
    indem Du die untenstehende URL besuchst:

    #{url}

    Falls du diese Änderung nicht beantragt hast,
    ignoriere diese Nachricht bitte.

    ==============================
    """)
  end
end
