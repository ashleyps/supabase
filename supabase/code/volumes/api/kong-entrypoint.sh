#!/bin/sh

awk '
{
  result = ""
  rest = $0
  while (match(rest, /\$[A-Za-z_][A-Za-z_0-9]*/)) {
    variable = substr(rest, RSTART + 1, RLENGTH - 1)
    if (variable in ENVIRON) {
      result = result substr(rest, 1, RSTART - 1) ENVIRON[variable]
    } else {
      result = result substr(rest, 1, RSTART + RLENGTH - 1)
    }
    rest = substr(rest, RSTART + RLENGTH)
  }
  print result rest
}' /home/kong/temp.yml > "$KONG_DECLARATIVE_CONFIG"

exec /docker-entrypoint.sh kong docker-start
