open Type;
open Util;

type config('model, 'msg) = {
  init: ('model, Cmd.t('msg)),
  update: ('msg, 'model) => ('model, Cmd.t('msg)),
  sub: 'model => Cmd.t('msg),
};

let useReducerT = config => {
  let {init, update, sub} = config;
  let cancel = React.useRef({queue: Js.Dict.empty(), id: 0});
  let (res, dispatch) = React.Uncurried.useReducer(any_cast(update), init);
  let (state, cmd) = res;

  React.useEffect1(
    () => {
      let makeRegister: makeRegister('a) =
        () => {
          let id = cancel.current.id |> string_of_int;
          cancel.current.id = cancel.current.id + 1;

          (
            (. action) => {
              dispatch(. action);
              Dict.delete(cancel.current.queue, id);
            },
            cb => Js.Dict.set(cancel.current.queue, id, cb),
          );
        };
      cmd(. makeRegister);
      None;
    },
    [|res|],
  );

  React.useEffect0(() => Some(() => cancel.current.queue |> Dict.values |> Js.Array.forEach(f => f())));
  (state, dispatch);
};

// module Comp = {
//   type config('model, 'msg) = {
//     init: ('model, Cmd.t),
//     update: ('msg, 'model) => ('model, Cmd.t),
//     sub: 'model => Sub.t('msg),
//     view: ('model, (. 'msg) => unit) => React.element,
//   };

//   let make = ({init, update, sub, view}) => {
//     let (model, dispatch) = useReducerT({init, update, sub});
//     view(model, dispatch);
//   };
// };
