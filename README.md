[![npm](https://img.shields.io/npm/v/@wicke/retask?style=flat-square)](https://www.npmjs.com/package/@wicke/retask)
[![Coveralls](https://img.shields.io/coveralls/github/Austaras/retask?style=flat-square)](https://coveralls.io/github/Austaras/retask)

## Elm task but with ReScript and React

It's \${currentYear} and there're sufficient reasons for not using Elm, yet there isn't a real alternative(except Elmish, but it has its own problem too). Not until the release of React hook, in which `useReducer` alone is powerful enough for mimicking TEA. However there is one big thing missing: side effect.

This package is intended to port said system to ReScript so you can write Elm without really having to write Elm, or more shortly, **Elm as a hook**. You could also use it in plain JavaScript or TypeScript.

Effect Manager:

-   [x] Task composition
-   [x] Time
-   [ ] Ajax
-   [x] WebSocket
-   [x] Dom Event

### Quick start

Install `@wicke/retask` use your favourite package manager.

And get the following example run on your favourite build system.

```rust
open ReTask;
[@react.component]
let make = () => {
    let (state, dispatch) = useReducerT({
        init: (0, Time.delay(1000, _ => 1)),
        update: (state, action) => (state + action, Cmd.none),
        sub: state => DomEvent.onDocument("click", ev => state)
    })

    <div>{state -> string_of_int -> React.string}</div>
}
```

or in JavaScript

```js
import React from 'react'
import { useReducerT, delay, noCmd, onDocument } from '@wicke/retask'

export function FooComp() {
    const [state, dispatch] = useReducerT({
        init: [0, delay(1000, () => 1)]
        update: (state, action) => [state + action, noCmd],
        sub: state => onDocument('click', ev => state)
    })

    return <div>{state}</div>
}
```

You would see a `0` on screen and then a `1` one second later, and every time you click on the screen, that number will double.

### Intro to ReTask

There are three elements in ReTask: `Cmd`, `Task` and `Sub`.

A `Cmd` is for one shot job like `setTimeout`. You may use `Cmd` to send message to your component or simply for performing side effects. For the former its constructor will take a `tagger` to map payload to your intended message. Don't worry if your jobs hasn't finished when your component is unmounting, they will be cancelled.

And what do you use when you want to compose two `Cmd`s? It doesn't make sense to provide each of them a tagger, so you should use `Task`. `Task` is like `Cmd` without tagger. Using `andThen`/`thenTask` you could make two tasks runing one by one. And then by `attempt`/`attemptTask` you could turn it into a `Cmd`. If the `Task` won't fail, `perform`/`performTask` is more simple.

`Sub`, on the other hand, is for long running job like `setInterval`. Every time it see fit, a `Sub` would send message to your component. And if such message cause a state change, your `sub` function will be recalled with updated state and calcuate a new `Sub`. If it's of different type or be constructed with different parameter, your old `Sub` will be cancelled. Beware that although ReScript is not a pure language unlike Elm, here parameter changes are still detected with `===`

### How to write your own effect manager

Currently there are some effect managers missing and things will occur that maybe you have some specific task to run. So here's a guide on how to write your own `Cmd | Task | Sub`.

A `Task` is merely a function who takes a callback as an argument and return a function for cancelling ongoing task.

```js
function voidTask(cb) {
    cb()
    return () => {}
}
```

And a `Cmd` is not far from it. In the function body, you call `register` so your task will be registered to your component. The returned value is for cancellation.

```js
import { register } from '@wicke/retask/lib/src/es6/cmd'

function voidCmd(tagger) {
    register(send => {
        send(tagger(payload))
        return () => {}
    })
}
```

TODO: `Sub`

### API Doc

TODO
