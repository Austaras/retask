open Util;

type t('payload) = (. ((. 'payload) => unit)) => Util.result;

let perform = (tagger: 'a => 'msg, task: t('a)) => {
  Cmd.register(send => {
    let cb = (. payload) => send(. tagger(payload));
    task(. cb);
  });
};

let andThen = (mapper: 'a => t('b), task: t('a)): t('b) => {
  (. cb) => {
    let cancelRef = ref(any_cast(0));
    let prepared =
      (. payload) => {
        let {cancel} = mapper(payload)(. cb);
        cancelRef := cancel;
      };
    cancelRef := task(. prepared).cancel;
    {cancel: (.) => cancelRef^(.)};
  };
};
