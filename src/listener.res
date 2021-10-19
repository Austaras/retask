type t<'msg, 'payload> = {
  @as("0")
  cb: array<(. 'msg) => unit>,
  @as("1")
  mutable payload: option<'payload>,
  @as("2")
  ctor: (. unit) => 'payload,
  @as("3")
  dtor: (. 'payload) => unit,
}

let make = (ctor, dtor) => {cb: [], payload: None, ctor: ctor, dtor: dtor}

let start = (inst: t<'msg, 'payload>, cb: (. 'msg) => unit) => {
  let _ = Js.Array2.push(inst.cb, cb)
  if Array.length(inst.cb) === 1 {
    inst.payload = Some(inst.ctor(.))
  }
}

let stop = (inst: t<'msg, 'payload>, cb: (. 'msg) => unit) => {
  let id = Js.Array2.indexOf(inst.cb, cb)
  if id >= 0 {
    let _ = Js.Array.removeCountInPlace(~pos=id, ~count=1, inst.cb)
  }
  switch inst.payload {
  | Some(payload) if Array.length(inst.cb) === 0 =>
    inst.dtor(. payload)
    inst.payload = None
  | _ => ()
  }
}
