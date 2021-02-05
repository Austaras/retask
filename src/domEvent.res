open Webapi.Dom

%%private(let record = Util.Map.make())

%%private(let token = Sub.getToken(__FILE__))

%%private(
  let onUniqueTarget = (event: string, tagger: Event.t => 'msg, element, name): Sub.t => {
    open Util
    let token = token ++ name
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
              element |> EventTarget.addEventListener(event, inst)
              inst
            },
            (. inst) => element |> EventTarget.removeEventListener(event, inst),
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
)

let onDocument = (event: string, tagger: Event.t => 'msg) =>
  onUniqueTarget(event, tagger, document |> Document.asEventTarget, "document")
let onWindow = (event: string, tagger: Event.t => 'msg) =>
  onUniqueTarget(event, tagger, window |> Window.asEventTarget, "window")
let onElement = (event, tagger, query: string) => switch document |> Document.querySelector(query) {
| Some(ele) => onUniqueTarget(event, tagger, ele |> Element.asEventTarget, query)
| None => raise(Not_found)
}
