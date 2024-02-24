APP_NAME="dievergolderei"
APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"
TAR_FILENAME=${APP_NAME}-${APP_VSN}.tar.gz

rsync ./rel/artifacts/${TAR_FILENAME} dievergolderei@dievergolderei.ch: