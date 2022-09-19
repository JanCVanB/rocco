n=0
for file in tests/*.json; do
  ((n=n+1))
  echo ""
  echo "~~~ TEST #$n ~~~"
  echo "    INPUT FILE: $file"
  echo "    INPUT DATA:"
  echo "`cat $file`"
  echo "    OUTPUT DATA:"
  roc dev -- post --payload "`cat $file`"
  curl \
    -X POST \
    http://localhost:8080 \
    -H "Content-Type: application/json" \
    -d "`cat $file`" ;
done
echo ""
