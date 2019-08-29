#!/bin/bash
set -e

mix credo  --strict
mix format --check-formatted
