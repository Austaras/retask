open Js.Global
open Webapi
open Util

let delay = (delay: int, tagger: unit => 'msg): Cmd.t =>
  (. ()) =>
    Cmd.register(send => {
      let id = setTimeout(() => send(. tagger()), delay)
      {cancel: (. ()) => clearTimeout(id)}
    })

%%private(let unit = ())

let sleep = (time: int): Task.t<unit, unit> =>
  (. cb) => {
    let id = setTimeout(() => cb(. Ok(unit)), time)
    {cancel: (. ()) => clearTimeout(id)}
  }

@bs.val external delayFloat: (float, unit => 'msg) => Cmd.t = "delay"
@bs.val external sleepFloat: float => Task.t<unit, unit> = "sleep"

let nextFrame = (tagger): Cmd.t =>
  (. ()) =>
    Cmd.register(send => {
      let id = requestCancellableAnimationFrame(time => send(. tagger(time)))
      {cancel: (. ()) => cancelAnimationFrame(id)}
    })

let token = Sub.getToken(__FILE__)

let every = (interval: int, tagger: unit => 'msg): Sub.t =>
  (. ()) => {
    let task = send => {
      let id = setInterval(() => send(. unit), interval)
      {cancel: (. ()) => clearInterval(id)}
    }
    Sub.register({kind: token, param: interval, task: task, tagger: tagger})
  }

@bs.val external everyFloat: (float, unit => 'msg) => Sub.t = "every"
