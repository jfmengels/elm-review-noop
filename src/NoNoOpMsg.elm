module NoNoOpMsg exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Declaration as Declaration exposing (Declaration)
import Elm.Syntax.Expression exposing (Expression)
import Elm.Syntax.Node as Node exposing (Node)
import Review.Rule as Rule exposing (Error, Rule)


{-| Reports... REPLACEME

    config =
        [ NoNoOpMsg.rule
        ]


## Fail

    a =
        "REPLACEME example to replace"


## Success

    a =
        "REPLACEME example to replace"


## When (not) to enable this rule

This rule is useful when REPLACEME.
This rule is not useful when REPLACEME.


## Try it out

You can try this rule out by running the following command:

```bash
elm - review --template jfmengels/elm-review-noop/example --rules NoNoOpMsg
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "NoNoOpMsg" ()
        |> Rule.withSimpleDeclarationVisitor declarationVisitor
        |> Rule.fromModuleRuleSchema


declarationVisitor : Node Declaration -> List (Error {})
declarationVisitor node =
    case Node.value node of
        Declaration.CustomTypeDeclaration { constructors } ->
            constructors
                |> List.map
                    (\constructor ->
                        constructor
                            |> Node.value
                            |> .name
                    )
                |> List.filter (\constructorName -> Node.value constructorName == "NoOp")
                |> List.map error

        _ ->
            []


error : Node String -> Error {}
error node =
    Rule.error
        { message = "Don't use NoOp, give it a better name"
        , details =
            [ "A Msg name should explain what happened. NoOp means tat nothing happened."
            , "Even if you don't care about handling the event, give it a name that describes what happened."
            , "Noah's talk on it: https://www.youtube.com/watch?v=w6OVDBqergc"
            ]
        }
        (Node.range node)



-- a + b
-- Node (OperatorApplication "+" _
--    (Node (FunctionOrValue [] "a"))
--    (Node (FunctionOrValue [] "b"))
