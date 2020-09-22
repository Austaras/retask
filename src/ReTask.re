module Cmd = {
  type t('msg) =
    | Cmd('msg);

  type batch('msg) = array(t('msg));

  let none = (): batch('msg) => [||];

  let map = (fn, msg) =>
    switch (msg) {
    | Cmd(a) => Cmd(fn(a))
    };
};

module Sub = {
  type t('msg) =
    | Sub('msg);

  type batch('msg) = array(t('msg));

  let none = (): batch('msg) => [||];

  let map = (fn, msg) =>
    switch (msg) {
    | Sub(a) => Sub(fn(a))
    };
};

type config('model, 'msg) = {
  init: ('model, Cmd.t('msg)),
  update: ('msg, 'model) => ('model, Cmd.t('msg)),
  sub: 'model => Sub.t('msg),
};

let useReducerT = config => {
  let {init, update, sub} = config;
  let update = React.useCallback1((state, action) => {
    let (state, _) = state;
    update(state, action);
  }, [|update|]);
  React.useEffect1(
    () => {
      Js.log(123);
      None;
    },
    [|sub|],
  );
  let ((state, cmd), action) = React.Uncurried.useReducer(update, init);

  React.useEffect1(
    () => {
      Js.log(123);
      None;
    },
    [|cmd|],
  );
  (state, action);
};
