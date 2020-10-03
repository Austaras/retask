open Js.Global;
open Webapi;

let delay: (unit => 'a, int) => Cmd.t('a) =
  (ctor, delay) =>
    (. make) => {
      let (fulfil, cancel) = make();
      let id = setTimeout(() => fulfil(. ctor()), delay);
      cancel(() => clearTimeout(id));
    };

let delayFloat: (unit => 'a, float) => Cmd.t('a) =
  (ctor, delay) =>
    (. make) => {
      let (fulfil, cancel) = make();
      let id = setTimeoutFloat(() => fulfil(. ctor()), delay);
      cancel(() => clearTimeout(id));
    };

let nextFrame = ctor =>
  (. make) => {
    let (fulfil, cancel) = make();
    let id = requestCancellableAnimationFrame(time => fulfil(. ctor(time)));
    cancel(() => cancelAnimationFrame(id));
  };

let every = 10;
let everyFloat = 10.0;
