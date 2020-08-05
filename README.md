# elm-review-noop

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to REPLACEME.


## Provided rules

- [`NoNoOpMsg`](https://package.elm-lang.org/packages/jfmengels/elm-review-noop/1.0.0/NoNoOpMsg) - Reports REPLACEME.


## Configuration

```elm
module ReviewConfig exposing (config)

import NoNoOpMsg
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ NoNoOpMsg.rule
    ]
```


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template jfmengels/elm-review-noop/example
```
