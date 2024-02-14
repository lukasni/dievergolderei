docker build -t dievergolderei_server .

APP_NAME="dievergolderei"
APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"
TAR_FILENAME=${APP_NAME}-${APP_VSN}.tar.gz

id=$(docker create ${APP_NAME}_server)
mkdir -p ./rel/artifacts
docker cp $id:/app/${TAR_FILENAME} ./rel/artifacts/
docker rm $id