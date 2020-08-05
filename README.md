*NOTES*: THIS IS UNPOLISHED
- The `NoUselessCmdNone` is not yet polished.
- These rules, if published, will likely not (all) end up in this package.

# elm-review-noop

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to forbid NoOp messages.

## Provided rules

- [`NoUselessCmdNone`](https://package.elm-lang.org/packages/jfmengels/elm-review-noop/1.0.0/NoUselessCmdNone) - Reports functions that never make use of their power to return Cmds.
- [`NoNoOpMsg`](https://package.elm-lang.org/packages/jfmengels/elm-review-noop/1.0.0/NoNoOpMsg) - Reports NoOp messages.


## Configuration

```elm
module ReviewConfig exposing (config)

import NoNoOpMsg
import NoUselessCmdNone
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ NoNoOpMsg.rule
    , NoUselessCmdNone.rule
    ]
```


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template jfmengels/elm-review-noop/example
```
