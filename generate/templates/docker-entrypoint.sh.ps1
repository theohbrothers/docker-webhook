@'
#!/bin/sh
set -eu

if [ $# -gt 0 ] && [ "${1#-}" != "$1" ]; then
    set -- webhook "$@"
fi

exec "$@"
'@
