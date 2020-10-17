![npm](https://img.shields.io/npm/v/@wicke/retask?style=flat-square)
![Coveralls github](https://img.shields.io/coveralls/github/Austaras/retask?style=flat-square)

### elm task but with rescript

There are sufficient reasons for not using elm, yet there isn't a real alternative(except Elmish, but it has its own problem too) until the release of React hook, in which `useReducer` alone is powerful enough for mimicing TEA. However there is one really big thing missing which is side effect handling.

The intention of this package is to port said system to rescript so you can write elm without really having to write elm, or more shortly, **elm as a hook**. You could also use it in plain JavaScript or (in future) TypeScript(for now you also need `bs-platform` installed).

Effect Manager:

- [x] Task composition
- [x] Time
- [ ] Ajax
- [x] WebSocket
- [x] Dom Event

### quick start

### How to write your own effect manager
