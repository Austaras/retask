open Webapi;

let%private record = Js.Dict.empty();

let%private token = Sub.getToken(__FILE__);

let on = (event: string, tagger: Dom.Event.t => 'msg): Sub.t => {
  (.) => {
    let task = send => {
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
                Dom.document |> Dom.Document.addEventListener(event, inst);
                inst;
              },
              (. inst) => Dom.document |> Dom.Document.removeEventListener(event, inst),
            );
          Js.Dict.set(record, event, listener);
          listener;
        };
      Listener.start(listener, send);
      Util.{cancel: (.) => Listener.stop(listener, send)};
    };
    Sub.register({kind: token, param: event, task, tagger});
  };
};
