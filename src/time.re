open Js.Global;
open Webapi;

let delay = (tagger: unit => 'msg, delay: int): Cmd.t =>
  (.) => {
    Cmd.register(send => {
      let id = setTimeout(() => send(. tagger()), delay);
      () => clearTimeout(id);
    });
  };

[@bs.val] external delayFloat: (unit => 'msg, float) => Cmd.t = "delay";

let nextFrame = (tagger): Cmd.t =>
  (.) => {
    Cmd.register(send => {
      let id = requestCancellableAnimationFrame(time => send(. tagger(time)));
      () => cancelAnimationFrame(id);
    });
  };

let token = Sub.getToken(__FILE__);

let unit = ();

let every = (tagger: unit => 'msg, interval: int): Sub.t =>
  (.) => {
    let task = send => {
      let id = setInterval(() => send(. unit), interval);
      () => clearInterval(id);
    };
    Sub.register({kind: token, param: interval, task, tagger});
  };

[@bs.val] external everyFloat: (unit => 'msg, float) => Sub.t = "every";
