open Js.Global;
open Webapi;

let delay = (tagger: unit => 'msg, delay: int): Cmd.t =>
  (.) => {
    Cmd.register(send => {
      let id = setTimeout(() => send(. tagger()), delay);
      () => clearTimeout(id);
    });
  };

let delayFloat = (tagger: unit => 'msg, delay: float): Cmd.t =>
  (.) => {
    Cmd.register(send => {
      let id = setTimeoutFloat(() => send(. tagger()), delay);
      () => clearTimeout(id);
    });
  };

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

let everyFloat = (tagger: unit => 'msg, interval: float): Sub.t =>
  (.) => {
    let task = send => {
      let id = setIntervalFloat(() => send(. unit), interval);
      () => clearInterval(id);
    };
    Sub.register({kind: token, param: interval, task, tagger});
  };
