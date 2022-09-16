roc dev -- post --payload "`cat tests/full.json`"

roc dev -- post --payload "`cat tests/less.json`"

roc dev -- post --payload "`cat tests/minimal.json`"

roc dev -- post --payload "`cat tests/bad.json`"
