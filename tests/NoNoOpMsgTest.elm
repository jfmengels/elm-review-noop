module NoNoOpMsgTest exposing (all)

import NoNoOpMsg exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


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
                            { message = "Don't use NoOp, give it a better name"
                            , details = [ "Go watch Noah's talk!" ]
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
        ]
