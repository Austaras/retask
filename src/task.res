type t<'data, 'err> = (. (. result<'data, 'err>) => unit) => Util.ret

let perform = (tagger: 'a => 'msg, task: t<'a, unit>) =>
  Cmd.register(send => {
    let cb = (. payload) =>
      switch payload {
      | Ok(data) => send(. tagger(data))
      | Error(_) => failwith("ERROR: Task perfom should never receive error")
      }
    task(. cb)
  })

let attempt = (tagger: result<'ok, 'err> => 'msg, task: t<'ok, 'err>) =>
  Cmd.register(send => {
    let cb = (. payload) => send(. tagger(payload))
    task(. cb)
  })

let andThen = (mapper: 'a => t<'b, 'err>, task: t<'a, 'err>): t<'b, 'err> =>
  (. cb) => {
    let cancelRef = ref(Util.any_cast(0))
    let prepared = (. payload) =>
      switch payload {
      | Ok(o) =>
        let {cancel} = mapper(o)(. cb)
        cancelRef := cancel
      | Error(e) => cb(. Error(e))
      }
    cancelRef := task(. prepared).cancel
    {cancel: (. ()) => cancelRef.contents(.)}
  }

let map = (mapper: 'a => 'b, task: t<'a, 'err>): t<'b, 'err> =>
  (. cb) => {
    let cb = (. payload) =>
      cb(.
        switch payload {
        | Ok(data) => Ok(mapper(data))
        | Error(e) => Error(e)
        },
      )
    task(. cb)
  }

let map2 = (mapper: ('a, 'b) => 'result, task1: t<'a, 'err>, task2: t<'b, 'err>): t<
  'result,
  'err,
> =>
  (. cb) => {
    let cancelRef = ref(Util.any_cast(0))
    let prepared = (. payload) =>
      switch payload {
      | Ok(a) =>
        let cb = (. payload) =>
          switch payload {
          | Ok(b) => cb(. Ok(mapper(a, b)))
          | Error(e) => cb(. Error(e))
          }
        let {cancel} = task2(. cb)
        cancelRef := cancel
      | Error(e) => cb(. Error(e))
      }
    cancelRef := task1(. prepared).cancel
    {cancel: (. ()) => cancelRef.contents(.)}
  }
