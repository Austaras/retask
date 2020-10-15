type send('msg) = (. 'msg) => unit;

type t = (. unit) => unit;

type reg('msg) = (send('msg) => Util.result) => unit;
let register: reg('msg) = _ => ();

[@warning "-27"]
let setReg: reg('msg) => unit = make => [%raw {js|register = make|js}];

let none: t = (.) => ();

let batch = (cmds: array(t)): t => (.) => cmds |> Js.Array.forEach(f => f(.));
