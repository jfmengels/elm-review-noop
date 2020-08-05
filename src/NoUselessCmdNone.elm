module NoUselessCmdNone exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.Node as Node exposing (Node(..))
import Review.Rule as Rule exposing (Error, Rule)


{-| Reports functions that never make use of their power to return Cmds.

    config =
        [ NoUselessCmdNone.rule
        ]


## Fail

    update msg model =
        case msg of
            ClickedIncrement ->
                ( model + 1, Cmd.none )

            ClickedDecrement ->
                ( model - 1, Cmd.none )


## Success

    update msg model =
        case msg of
            ClickedIncrement ->
                model + 1

            ClickedDecrement ->
                model - 1


## When (not) to enable this rule

This rule is not useful when you are writing a package.


## Try it out

You can try this rule out by running the following command:

```bash
elm - review --template jfmengels/elm-review-noop/example --rules NoUselessCmdNone
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "NoUselessCmdNone" ()
        |> Rule.withSimpleExpressionVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


expressionVisitor : Node Expression -> List (Error {})
expressionVisitor node =
    case Node.value node of
        Expression.CaseExpression { cases } ->
            cases
                |> List.concatMap
                    (\( _, expression ) ->
                        case Node.value expression of
                            Expression.TupledExpression (_ :: (Node range (Expression.FunctionOrValue [ "Cmd" ] "none")) :: []) ->
                                [ Rule.error
                                    { message = "REPLACEME"
                                    , details = [ "REPLACEME" ]
                                    }
                                    range
                                ]

                            _ ->
                                []
                    )

        _ ->
            []
