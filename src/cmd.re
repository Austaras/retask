open Type;

type t('a) = (. makeRegister('a)) => unit;

let none: t('a) = (. _) => ();

let batch = (cmds: array(t('a))): t('a) => (. make) => cmds |> Js.Array.forEach(f => f(. make));
