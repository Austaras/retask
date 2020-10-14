open Webapi;

let%private record = Js.Dict.empty();

let%private token = Sub.getToken(__FILE__)

let on = (event: string, tagger: Dom.Event.t => 'msg): Sub.t => {
  (.) => {
    let task = send => {
      open Dom;
      open Document;

      let listener =
        switch (Js.Dict.get(record, event)) {
        | Some(listener) => listener
        | None =>
          let listener =
            Listener.make(
              (.) => {
                let inst = ev => {
                  open Listener;
                  let {cb} = Js.Dict.unsafeGet(record, event);
                  Js.Array2.forEach(cb, c => c(. ev));
                };
                document |> addEventListener(event, inst);
                inst;
              },
              (. inst) => document |> removeEventListener(event, inst),
            );
          Js.Dict.set(record, event, listener);
          listener;
        };
      Listener.start(listener, send);
      () => Listener.stop(listener, send);
    };
    Sub.register({kind: token, param: event, task, tagger});
  };
};
