#!/bin/sh

rm -rf priv/static

mix deps.get --only prod
MIX_ENV=prod mix compile

npm run deploy --prefix ./assets
mix phx.digest

MIX_ENV=prod mix release