open Js.Global;
open Webapi;

let delay = (delay: int, tagger: unit => 'msg): Cmd.t =>
  (.) => {
    Cmd.register(send => {
      let id = setTimeout(() => send(. tagger()), delay);
      () => clearTimeout(id);
    });
  };

[@bs.val] external delayFloat: (float, unit => 'msg) => Cmd.t = "delay";

let nextFrame = (tagger): Cmd.t =>
  (.) => {
    Cmd.register(send => {
      let id = requestCancellableAnimationFrame(time => send(. tagger(time)));
      () => cancelAnimationFrame(id);
    });
  };

let token = Sub.getToken(__FILE__);

let unit = ();

let every = (interval: int, tagger: unit => 'msg): Sub.t =>
  (.) => {
    let task = send => {
      let id = setInterval(() => send(. unit), interval);
      () => clearInterval(id);
    };
    Sub.register({kind: token, param: interval, task, tagger});
  };

[@bs.val] external everyFloat: (float, unit => 'msg) => Sub.t = "every";
