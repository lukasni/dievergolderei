# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :dievergolderei, Dievergolderei.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

lv_signing_salt =
  System.get_env("LIVEVIEW_SIGNING_SALT") ||
    raise """
    environment variable LIVEVIEW_SIGNING_SALT is missing.
    You can generate one by calling mix phx.gen.secret 32
    """

config :dievergolderei, DievergoldereiWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "80")],
  url: [host: "dievergolderei.ch", port: 443, scheme: "https"],
  secret_key_base: secret_key_base,
  server: true,
  live_view: [
    signing_salt: lv_signing_salt
  ],
  force_ssl: [hsts: true],
  https: [
    :inet6,
    port: 443,
    cipher_suite: :compatible,
    keyfile: System.get_env("SSL_KEY_FILE"),
    certfile: System.get_env("SSL_CERT_FILE"),
    cacertfile: System.get_env("SSL_CACERT_FILE"),
    dhfile: System.get_env("SSL_DHPARAM_FILE")
  ]

upload_directory =
  System.get_env("UPLOAD_DIRECTORY") ||
    raise """
    environment variable UPLOAD_DIRECTORY is missing.
    """

config :dievergolderei, Dievergolderei.Photo, upload_directory: upload_directory

