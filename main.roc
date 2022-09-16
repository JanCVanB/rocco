app "rocco"
    packages { pf: "roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.Arg, pf.Stdout, pf.Task]
    provides [main] to pf

main : List Str -> Task.Task {} [] [Write [Stdout]]
main = \args ->
    when Arg.parseFormatted parser args is
        Ok command -> run command |> Stdout.line
        Err helpMenu -> helpMenu |> Stdout.line

parser =
    Arg.choice [postSubcommand]
    |> Arg.program { name: "rocco", help: "A chat bot written in Roc for Zulip" }

postSubcommand =
    Arg.succeed (\request -> Post request)
    |> Arg.withParser
        (
            Arg.str {
                long: "payload",
                short: "p",
                help: "the POST request payload for the \"outgoing webhook\"-type Zulip chat bot to respond to; corresponds to the trigger message mentioning (or a private message to) the chat bot; see https://zulip.com/api/outgoing-webhooks#outgoing-webhook-format",
            }
        )
    |> Arg.subCommand "post"

respond = \request ->
    # TODO: Upgrade request parsing with `Json` library
    after = \text, mark ->
        when Str.splitFirst text mark is
            Ok x -> x.after
            Err _ -> ""
    before = \text, mark ->
        # Remove this outer `when` if this issue is fixed:
        # https://github.com/roc-lang/roc/issues/4064
        when text is
            "" -> ""
            _ ->
                when Str.splitFirst text mark is
                    Ok x -> x.before
                    Err _ -> text
    message =
        request
        |> after "\"content\": \""
        |> before "\""
    "{\"content\": \"I heard you say `\(message)` 🙂\"}"

run = \command ->
    when command is
        Post request -> respond request
