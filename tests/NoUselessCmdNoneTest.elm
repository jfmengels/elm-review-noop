module NoUselessCmdNoneTest exposing (all)

import NoUselessCmdNone exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


message : String
message =
    "This function always returns Cmd.none"


details : List String
details =
    [ "Since this function returns Cmd.none in all cases, you can simplify it by having it not return a Cmd."
    ]


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
                            { message = message
                            , details = details
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
        , test "should report errors when all branches return Cmd.none" <|
            \() ->
                """module A exposing (..)
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ClickedIncrement ->
        ( model + 1, Cmd.none )
    ClickedDecrement ->
        ( model - 1, Cmd.none )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = message
                            , details = details
                            , under = "Cmd.none"
                            }
                            |> Review.Test.atExactly { start = { row = 6, column = 22 }, end = { row = 6, column = 30 } }
                        , Review.Test.error
                            { message = message
                            , details = details
                            , under = "Cmd.none"
                            }
                            |> Review.Test.atExactly { start = { row = 8, column = 22 }, end = { row = 8, column = 30 } }
                        ]
        , test "should report errors when Cmd.none is used using an unqualified import" <|
            \() ->
                """module A exposing (..)
import Platform.Cmd exposing (none)
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ClickedIncrement ->
        ( model + 1, none )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = message
                            , details = details
                            , under = "none"
                            }
                            |> Review.Test.atExactly { start = { row = 7, column = 22 }, end = { row = 7, column = 26 } }
                        ]
        , test "should report errors when Cmd.none is used using exposing (..)" <|
            \() ->
                """module A exposing (..)
import Platform.Cmd exposing (..)
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ClickedIncrement ->
        ( model + 1, none )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = message
                            , details = details
                            , under = "none"
                            }
                            |> Review.Test.atExactly { start = { row = 7, column = 22 }, end = { row = 7, column = 26 } }
                        ]
        , test "should not report errors when something else than Cmd.none is used in a branch of an if expression" <|
            \() ->
                """module A exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  if something then
    ( model + 1, Cmd.none )
  else
    ( model - 1, cmd )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should report errors when Cmd.none is used in both branches of an if expression" <|
            \() ->
                """module A exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  if something then
    ( model + 1, Cmd.none )
  else
    ( model - 1, Cmd.none )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = message
                            , details = details
                            , under = "Cmd.none"
                            }
                            |> Review.Test.atExactly { start = { row = 6, column = 18 }, end = { row = 6, column = 26 } }
                        , Review.Test.error
                            { message = message
                            , details = details
                            , under = "Cmd.none"
                            }
                            |> Review.Test.atExactly { start = { row = 8, column = 18 }, end = { row = 8, column = 26 } }
                        ]
        , test "should not report errors when something else than Cmd.none is used in a let expression" <|
            \() ->
                """module A exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ClickedIncrement ->
        let
          _ = ()
        in
        ( model + 1, cmd )
    ClickedDecrement ->
        ( model - 1, Cmd.none )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should report errors when a branch contains a let expression but returns Cmd.none" <|
            \() ->
                """module A exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ClickedIncrement ->
        let
          _ = ()
        in
        ( model + 1, Cmd.none )
    ClickedDecrement ->
        ( model - 1, Cmd.none )
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = message
                            , details = details
                            , under = "Cmd.none"
                            }
                            |> Review.Test.atExactly { start = { row = 10, column = 22 }, end = { row = 10, column = 30 } }
                        , Review.Test.error
                            { message = message
                            , details = details
                            , under = "Cmd.none"
                            }
                            |> Review.Test.atExactly { start = { row = 12, column = 22 }, end = { row = 12, column = 30 } }
                        ]
        , test "should not report Cmd.none that's not in a return value" <|
            \() ->
                """module A exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    if (case msg of
          ClickedIncrement ->
            ( model + 1, Cmd.none )
        ) |> Tuple.first
    then
        (model, cmd)
    else
        (model, cmd2)
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors []
        ]
