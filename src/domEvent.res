open Webapi

%%private(let record = Util.Map.make())

%%private(let token = Sub.getToken(__FILE__))

%%private(let getName = %raw(`ele => ele.constructor.name`))

let onUniqueTarget = (element, event: string, tagger: Dom.Event.t => 'msg): Sub.t => {
  open Util
  let token = token ++ getName(element)
  let record = switch Map.get(record, element) {
  | Some(r) => r
  | None => {
      let r = Js.Dict.empty()
      Map.set(record, element, r)
      r
    }
  }
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
            element |> Dom.EventTarget.addEventListener(event, inst)
            inst
          },
          (. inst) => element |> Dom.EventTarget.removeEventListener(event, inst),
        )
        Js.Dict.set(record, event, listener)
        listener
      }
      Listener.start(listener, send)
      {cancel: (. ()) => Listener.stop(listener, send)}
    }
    Sub.register({kind: token, param: event, task: task, tagger: tagger})
  }
}

let onDocument = (event: string, tagger: Dom.Event.t => 'msg) =>
  onUniqueTarget(Dom.Document.asEventTarget(Dom.document), event, tagger)
let onWindow = (event: string, tagger: Dom.Event.t => 'msg) =>
  onUniqueTarget(Dom.Window.asEventTarget(Dom.window), event, tagger)
