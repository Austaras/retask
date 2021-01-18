%%private(let record = Util.Map.make())
%%private(let token = Sub.getToken(__FILE__))

let on = (ws: WebSocket.t, tagger: WebSocket.MessageEvent.t => 'msg): Sub.t =>
  (. ()) => {
    let task = send => {
      let listener = switch Util.Map.get(record, ws) {
      | Some(listener) => listener
      | None =>
        let listener = Listener.make(
          (. ()) => {
            let inst = msg => {
              open Listener
              let {cb} = Util.Map.unsafeGet(record, ws)
              Js.Array2.forEach(cb, c => c(. msg))
            }
            WebSocket.addEventListener(ws, #message(inst))
            inst
          },
          (. inst) => WebSocket.removeEventListener(ws, #message(inst)),
        )
        Util.Map.set(record, ws, listener)
        listener
      }
      Listener.start(listener, send)
      open Util
      {cancel: (. ()) => Listener.stop(listener, send)}
    }
    Sub.register({kind: token, param: ws, task: task, tagger: tagger})
  }

let send = (ws: WebSocket.t, msg: string): Cmd.t => (. ()) => ws.send(. msg)

%%private(let recordU = Js.Dict.empty())

%%private(let tokenU = token ++ "U")

let makeListener = url =>
  switch Js.Dict.get(recordU, url) {
  | Some(listener) => listener
  | None =>
    let listener = Listener.make(
      (. ()) => {
        let inst = WebSocket.make(url)
        inst.onmessage = msg => {
          open Listener
          let {cb} = Js.Dict.unsafeGet(recordU, url)
          Js.Array2.forEach(cb, c => c(. msg))
        }
        inst
      },
      (. inst) => inst.close(.),
    )
    Js.Dict.set(recordU, url, listener)
    listener
  }

let onUrl = (url: string, tagger: WebSocket.MessageEvent.t => 'msg): Sub.t =>
  (. ()) => {
    let task = send => {
      let listener = makeListener(url)

      Listener.start(listener, send)
      open Util
      {cancel: (. ()) => Listener.stop(listener, send)}
    }
    Sub.register({kind: tokenU, param: url, task: task, tagger: tagger})
  }

let sendUrl = (url: string, msg: string): Cmd.t =>
  (. ()) => {
    let listener = makeListener(url)
    let nothing = (. _) => ()
    if listener.payload === None {
      Listener.start(listener, nothing)
    }
    Cmd.register(_ => {
      open Util
      let ws = \"!!"(listener.payload)
      ws.send(. msg)
      {cancel: (. ()) => Listener.stop(listener, nothing)}
    })
  }
