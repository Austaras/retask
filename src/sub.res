type t = (. unit) => unit

type send<'payload> = (. 'payload) => unit

type instance<'param, 'payload, 'msg> = {
  kind: string,
  param: 'param,
  task: send<'payload> => Util.ret,
  tagger: 'payload => 'msg,
}

type reg<'param, 'payload, 'msg> = instance<'param, 'payload, 'msg> => unit

let register: reg<'param, 'payload, 'msg> = _ => ()

@warning("-27")
let setReg: reg<'param, 'payload, 'msg> => unit = make => %raw(`register = make`)

let none: t = (. ()) => ()

let batch = (subs: array<t>): t => (. ()) => subs |> Js.Array.forEach(f => f(.))

let getToken = str => (str |> Js.String.split("."))->Js.Array.unsafe_get(0)

%%private(
  let diff_array = %raw(`function (arr, oldArr) {
    if (arr.length !== oldArr.length) return false
    for (let i = 0;i< arr.length; i++) {
        if (arr[i] !== oldArr[i]) return false
    }
    return true
}
`)
)

let sameSub = (kind: string, param: 'param, oldKind: string, oldParam: 'param): bool => {
  switch (kind === oldKind, Js.Array.isArray(param), Js.Array.isArray(oldParam)) {
  | (false, _, _) => false
  | (true, true, true) => diff_array(param, oldParam)
  | (true, false, false) => param === oldParam
  | (true, _, _) => false
  }
}
