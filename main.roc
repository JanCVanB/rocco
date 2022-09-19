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

parse : Str -> Str
parse = \request ->
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
    request
    |> after "\"content\": \""
    |> before "\""

reply : Str -> Str
reply = \message ->
    words = message |> Str.split " "
    mode = words |> List.get 1
    args = words |> List.drop 2
    when mode is
        Ok "echo" -> args |> Str.joinWith " "
        Ok "issue" ->
            when args |> List.get 0 is
                Ok i -> "https://github.com/roc-lang/roc/issues/\(i)"
                Err _ -> "Which issue do you want?\\nFor example, '@**rocco** issue 664' :smile:"
        Ok "pr" ->
            when args |> List.get 0 is
                Ok p -> "https://github.com/roc-lang/roc/pulls/\(p)"
                Err _ -> "Which issue do you want?\\nFor example, '@**rocco** issue 664' :smile:"
        Ok "help" -> "Hi, I'm @**rocco**, a Roc chat bot!\\nSubcommands: `echo`, `help`, `issue`, `pr`\\nSee https://github.com/JanCVanB/rocco :smile:"
        Ok _ -> "Sorry, I don't understand.\\nTry '@**rocco** help' :smile:"
        Err _ -> "Hi, I'm @**rocco**, a Roc chat bot!\\nSend '@**rocco** help' to learn more about me. :smile:"

formatResponse = \message -> "{ \"content\": \"\(message)\" }"

run = \command ->
    when command is
        Post request -> request |> parse |> reply |> formatResponse
