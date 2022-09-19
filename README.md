# rocco

A chat bot written in [Roc](https://roc-lang.org) for [Zulip](https://zulip.com)
(specifically for [the Roc chat](https://roc.zulipchat.com))

## Edit me! Fix me! Improve me!

Contributions are VERY welcome.
Please fix bugs, make improvements, and add features.
In fact, feel free to add your own apps as subcommands,
for easier deployment & testing of prototypes in the cloud.

I hope this project can become a communal effort,
because I don't have the time to make this as awesome as it could be!

## Notes

We use a Go app as a web server wrapper/caller for the Roc app.
In the future, this should be replaced by absorbing all web server functionality
into the Roc app, but today that is not easy.
