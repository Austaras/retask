### elm task but with rescript

There are sufficient reasons for not using elm, however there isn't a real alternative up until the release of React hook(except Elmish, but it has its own problem), in which `useReducer` alone is powerful enough for mimicing TEA. However there is one really big thing missing which is side effect handling.

The intention of this package is to port said system to rescript so you can write elm without really having to write elm, or more shortly, **elm as a hook**. You could also use it in plain JavaScript or (in future) TypeScript.

Effect Manager:

- [ ] Task composition
- [x] Time
- [ ] Ajax
- [ ] WebSocket
- [ ] Dom Event

### How to write your own effect manager
