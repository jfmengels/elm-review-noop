module NoUselessCmdNoneTest exposing (all)

import NoUselessCmdNone exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "NoUselessCmdNone"
        [ test "should report an error when all branches return a tuple with Cmd.none" <|
            \() ->
                """module A exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedIncrement ->
            ( model + 1, Cmd.none )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "REPLACEME"
                            , details = [ "REPLACEME" ]
                            , under = "Cmd.none"
                            }
                        ]
        , test "should not report an error when a branch returns something else than Cmd.none" <|
            \() ->
                """module A exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedIncrement ->
            ( model + 1, 1 )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should not report an error when some branches return a real command" <|
            \() ->
                """module A exposing (..)
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ClickedIncrement ->
        ( model + 1, Cmd.none )
    ClickedDecrement ->
        ( model - 1, Bugsnag.error "User wanted to decrement the counter!" )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        ]
