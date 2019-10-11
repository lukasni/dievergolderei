# Die Vergolderei

[![Build Status](https://travis-ci.org/lukasni/dievergolderei.svg?branch=master)](https://travis-ci.org/lukasni/dievergolderei)
[![Coverage Status](https://coveralls.io/repos/github/lukasni/dievergolderei/badge.svg?branch=master)](https://coveralls.io/github/lukasni/dievergolderei?branch=master)

Complete code for Die Vergolderei

First production-ready release, feature complete with redesigned gallery.

## Release

To build a new release, simply run release.sh in the mix project directory.

The script will delete the current compiled static files, then run the 
basic deployment steps outlined in the [Phoenix deployment docs](https://hexdocs.pm/phoenix/deployment.html)

## Requirements

Install mix dependencies by running `mix deps.get && mix deps.compile`

Releases >= 1.1.0 also require ImageMagick to be installed on the server
for performing image transformations.