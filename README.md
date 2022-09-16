# rocco

A chat bot written in [Roc](https://roc-lang.org) for [Zulip](https://zulip.com)
(specifically for [the Roc chat](https://roc.zulipchat.com))

## Notes

We use a Go app as a web server wrapper/caller for the Roc app.
In the future, this should be replaced by absorbing all web server functionality
into the Roc app, but today that is not easy.
