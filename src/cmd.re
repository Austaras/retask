open Util;

type send('msg) = (. 'msg) => unit;

type t = (. unit) => unit;

type reg('msg) = ((send('msg), unit) => unit) => unit;
let register: reg('msg) = _ => any_cast();

[@warning "-27"]
let setReg: reg('msg) => unit = make => [%raw {js|register = make|js}];

let none: t = (.) => ();

let batch = (cmds: array(t)): t => (.) => cmds |> Js.Array.forEach(f => f(.));
