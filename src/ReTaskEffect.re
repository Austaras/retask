let effect = Js.Dict.empty()

let getToken = name => Js.String.split(".", name)[0];

let register = (token, manager: unit => unit) => Js.Dict.set(effect, token, manager)