module NoNoOpMsgTest exposing (all)

import NoNoOpMsg exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


message : String
message =
    "Don't use NoOp, give it a better name"


details : List String
details =
    [ "A Msg name should explain what happened. NoOp means tat nothing happened."
    , "Even if you don't care about handling the event, give it a name that describes what happened."
    , "Noah's talk on it: https://www.youtube.com/watch?v=w6OVDBqergc"
    ]


all : Test
all =
    describe "NoNoOpMsg"
        [ test "should report an error when there is a NoOp Msg constructor" <|
            \() ->
                """module A exposing (..)
type Msg
  = NoOp
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = message
                            , details = details
                            , under = "NoOp"
                            }
                        ]
        , test "should not report an error when there is no custom type" <|
            \() ->
                """module A exposing (..)
a = 1
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should not report an error when the constrcutor name is not NoOp" <|
            \() ->
                """module A exposing (..)
type Msg
  = Foo
  | Bar
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        ]
