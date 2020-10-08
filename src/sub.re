open Util;

type t = (. unit) => unit;

type send('payload) = (. 'payload) => unit;

type instance('param, 'payload, 'msg) = {
  kind: string,
  param: 'param,
  task: send('payload) => unit => unit,
  tagger: 'payload => 'msg,
};

type reg('param, 'payload, 'msg) = instance('param, 'payload, 'msg) => unit;

let register: reg('param, 'payload, 'msg) = _ => any_cast();

[@warning "-27"]
let setReg: reg('param, 'payload, 'msg) => unit = make => [%raw {js|register = make|js}];

let none: t = (.) => ();

let batch = (subs: array(t)): t => (.) => subs |> Js.Array.forEach(f => f(.));

// https://github.com/rescript-lang/rescript-compiler/issues/4607
[@inline]
let getToken = str => (str |> Js.String.split("."))->Js.Array.unsafe_get(0);
[@bs.module "./diff"] external sameSub: (string, 'param, string, 'param) => bool = "sameSub";
