app "rocco"
    packages { pf: "roc/examples/interactive/cli-platform/main.roc" }
    imports [Json, pf.Arg, pf.Stdout, pf.Task]
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

respond : Str -> Str
respond = \request ->
    reply = when Decode.fromBytes request Json.fromUtf8 is
        Ok { message: { content } } ->
            "I heard you say `\(content)` 🙂"
        _ ->
            "Sorry, I couldn't understand that. ☹️"
    """{ "content": "\(reply)" }"""

run = \command ->
    when command is
        Post request -> respond request
