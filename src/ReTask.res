open Util

type config<'model, 'msg> = {
  init: ('model, Cmd.t),
  update: ('model, 'msg) => ('model, Cmd.t),
  sub: 'model => Sub.t,
}

type subState<'msg> = {
  @bs.as("0")
  kind: string,
  @bs.as("1")
  cancel: (. unit) => unit,
  @bs.as("2")
  mutable tagger: unit => 'msg,
  @bs.as("3")
  param: unit,
}

type cancel<'msg> = {
  @bs.as("0")
  cmdQueue: Js.Dict.t<Util.ret>,
  @bs.as("1")
  subQueue: array<subState<'msg>>,
  @bs.as("2")
  mutable id: int,
}

let useReducerT = (config: config<'model, 'msg>) => {
  let {init, update, sub} = config
  let cancel = React.useRef({cmdQueue: Js.Dict.empty(), subQueue: [], id: 0})
  let (res, dispatch) = React.Uncurried.useReducer(
    ((state, _), action) => update(state, action),
    init,
  )
  let (state, cmd) = res

  // for command
  React.useEffect1(() => {
    Cmd.setReg(task => {
      let id = cancel.current.id |> string_of_int
      cancel.current.id = cancel.current.id + 1

      let dispatch = (. action) => {
        dispatch(. action)
        Dict.delete(cancel.current.cmdQueue, id)
      }
      let cb = task(dispatch)
      Js.Dict.set(cancel.current.cmdQueue, id, cb)
    })
    cmd(.)
    None
  }, [res])

  // for subscription
  React.useEffect2(() => {
    open! Sub
    let count = ref(0)
    let queue = cancel.current.subQueue
    setReg(inst => {
      let id = count.contents
      count := count.contents + 1
      let dispatch = (. payload) => {
        let msg = Js.Array.unsafe_get(queue, id).tagger(any_cast(payload))
        dispatch(. msg)
      }
      let old = Belt.Array.get(queue, id)
      switch old {
      | Some(old) when sameSub(inst.kind, inst.param, old.kind, old.param) =>
        old.tagger = inst.tagger
      | Some(old) =>
        old.cancel(.)
        let {kind, param, tagger, task} = inst
        let {Util.cancel: cancel} = task(dispatch)
        Js.Array.unsafe_set(queue, id, {kind: kind, param: param, tagger: tagger, cancel: cancel})
      | None =>
        let {kind, param, tagger, task} = inst
        let {Util.cancel: cancel} = task(dispatch)
        Js.Array.unsafe_set(queue, id, {kind: kind, param: param, tagger: tagger, cancel: cancel})
      }
    })
    sub(state)(.)
    let count = count.contents
    while queue |> Array.length > count {
      JsArray.pop(queue).cancel(.)
    }
    None
  }, (sub, state))

  // cancel when unmount
  React.useEffect0(() => Some(
    () => {
      cancel.current.cmdQueue
      |> Dict.values
      |> {
        open Util
        Js.Array.forEach(f => f.cancel(.))
      }
      cancel.current.subQueue |> Js.Array.forEach(f => f.cancel(.))
    },
  ))
  (state, dispatch)
}

// TODO: make this work
type compConfig<'model, 'msg> = {
  init: ('model, Cmd.t),
  update: ('msg, 'model) => ('model, Cmd.t),
  sub: 'model => Sub.t,
  view: ('model, (. 'msg) => unit) => React.element,
}

let make = ({init, update, sub, view}) => {
  let (model, dispatch) = useReducerT({init: init, update: update, sub: sub})
  view(model, dispatch)
}
