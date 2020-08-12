module NoUselessCmdNone exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.Node as Node exposing (Node(..))
import Elm.Syntax.Range exposing (Range)
import Review.Rule as Rule exposing (Error, Rule)
import Scope


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
elm - review --template jfmengels/elm-review-noop/preview --rules NoUselessCmdNone
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "NoUselessCmdNone" initialContext
        |> Scope.addModuleVisitors
        |> Rule.withExpressionEnterVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


type alias Context =
    { scope : Scope.ModuleContext
    }


initialContext : Context
initialContext =
    { scope = Scope.initialModuleContext
    }


expressionVisitor : Node Expression -> Context -> ( List (Error {}), Context )
expressionVisitor node context =
    case getBranches node of
        Just expressions ->
            let
                rangesWithViolation : List (Maybe Range)
                rangesWithViolation =
                    List.map (resultsInCmdNone context) expressions
            in
            if List.all ((/=) Nothing) rangesWithViolation then
                ( rangesWithViolation
                    |> List.filterMap identity
                    |> List.map error
                , context
                )

            else
                ( [], context )

        Nothing ->
            ( [], context )


getBranches : Node Expression -> Maybe (List (Node Expression))
getBranches node =
    case Node.value node of
        Expression.CaseExpression { cases } ->
            Just (List.map Tuple.second cases)

        Expression.IfBlock _ ifExpr elseExpr ->
            Just [ ifExpr, elseExpr ]

        Expression.LetExpression { expression } ->
            getBranches expression

        _ ->
            Nothing


resultsInCmdNone : Context -> Node Expression -> Maybe Range
resultsInCmdNone context node =
    case Node.value node of
        Expression.TupledExpression (_ :: (Node range (Expression.FunctionOrValue moduleName "none")) :: []) ->
            if Scope.moduleNameForValue context.scope "none" moduleName == [ "Platform", "Cmd" ] then
                Just range

            else
                Nothing

        Expression.LetExpression { expression } ->
            resultsInCmdNone context expression

        _ ->
            Nothing


error : Range -> Error {}
error range =
    Rule.error
        { message = "This function always returns Cmd.none"
        , details =
            [ "Since this function returns Cmd.none in all cases, you can simplify it by having it not return a Cmd."
            ]
        }
        range
