curl \
  -X POST \
  http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d "`cat tests/full.json`"

curl -X POST \
  http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d "`cat tests/less.json`"

curl \
  -X POST \
  http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d "`cat tests/minimal.json`"

curl \
  -X POST \
  http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d "`cat tests/bad.json`"
