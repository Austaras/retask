open Webapi

%%private(let record = Js.Dict.empty())

%%private(let token = Sub.getToken(__FILE__))

let onDocument = (event: string, tagger: Dom.Event.t => 'msg): Sub.t =>
  (. ()) => {
    let task = send => {
      let listener = switch Js.Dict.get(record, event) {
      | Some(listener) => listener
      | None =>
        let listener = Listener.make(
          (. ()) => {
            let inst = ev => {
              open Listener
              let {cb} = Js.Dict.unsafeGet(record, event)
              Js.Array2.forEach(cb, c => c(. ev))
            }
            Dom.document |> Dom.Document.addEventListener(event, inst)
            inst
          },
          (. inst) => Dom.document |> Dom.Document.removeEventListener(event, inst),
        )
        Js.Dict.set(record, event, listener)
        listener
      }
      Listener.start(listener, send)
      open Util
      {cancel: (. ()) => Listener.stop(listener, send)}
    }
    Sub.register({kind: token, param: event, task: task, tagger: tagger})
  }

%%private(let recordW = Js.Dict.empty())

%%private(let tokenW = Sub.getToken(__FILE__) ++ "window")

let onWindow = (event: string, tagger: Dom.Event.t => 'msg): Sub.t =>
  (. ()) => {
    let task = send => {
      let listener = switch Js.Dict.get(recordW, event) {
      | Some(listener) => listener
      | None =>
        let listener = Listener.make(
          (. ()) => {
            let inst = ev => {
              open Listener
              let {cb} = Js.Dict.unsafeGet(recordW, event)
              Js.Array2.forEach(cb, c => c(. ev))
            }
            Dom.window |> Dom.Window.addEventListener(event, inst)
            inst
          },
          (. inst) => Dom.window |> Dom.Window.removeEventListener(event, inst),
        )
        Js.Dict.set(recordW, event, listener)
        listener
      }
      Listener.start(listener, send)
      open Util
      {cancel: (. ()) => Listener.stop(listener, send)}
    }
    Sub.register({kind: tokenW, param: event, task: task, tagger: tagger})
  }
