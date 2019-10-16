# Die Vergolderei

[![Build Status](https://travis-ci.org/lukasni/dievergolderei.svg?branch=master)](https://travis-ci.org/lukasni/dievergolderei)
[![Coverage Status](https://coveralls.io/repos/github/lukasni/dievergolderei/badge.svg?branch=master)](https://coveralls.io/github/lukasni/dievergolderei?branch=master)

Complete code for Die Vergolderei

First production-ready release, feature complete with redesigned gallery.

## Release

To build a new release, simply run `./release.sh` in the mix project directory.

The script will delete the current compiled static files, then run the 
basic deployment steps outlined in the [Phoenix deployment docs](https://hexdocs.pm/phoenix/deployment.html)

## Requirements

Install mix dependencies by running `mix deps.get && mix deps.compile`

Releases >= 1.1.0 also require ImageMagick to be installed on the server
for performing image transformations.

## Running the release

Releases are best run as a systemd unit. 

### Example systemd unit file

```
[Unit]
Description=Die Vergolderei
After=network.target
Requires=network.target

[Service]
Type=simple
WorkingDirectory=/opt/dievergolderei
User=dv_user
Group=dv_user
Restart=always
RestartSec=5
StartLimitBurst=3
StartLimitInterval=20
EnvironmentFile=/home/dv_user/dv_env_vars
ExecStart=/opt/dievergolderei/bin/dievergolderei start
ExecStop=/opt/dievergolderei/bin/dievergolderei stop

[Install]
WantedBy=multi-user.target
```

### Example environment file

This is the environment file defined in the systemd unit.
It defines all the runtime configuration variables
required by `config/releases.exs`

```
DATABASE_URL=ecto://user:password@host:port/database
POOL_SIZE=10
SECRET_KEY_BASE=secret key generated with mix phx.gen.secret
PORT=80
SSL_KEY_FILE=/etc/letsencrypt/live/domain.tld/privkey.pem
SSL_CACERT_FILE=/etc/letsencrypt/live/domain.tld/chain.pem
SSL_CERT_FILE=/etc/letsencrypt/live/domain.tld/cert.pem
SSL_DHPARAM_FILE=/etc/letsencrypt/dhparam.pem
UPLOAD_DIRECTORY=/path/to/uploads
```

With both files created, the release can be run using systemd

```
$ sudo systemctl start dievergolderei.servce
```