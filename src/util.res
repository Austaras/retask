@unboxed
type ret = {cancel: (. unit) => unit}

external any_cast: 'a => 'b = "%identity"

module Dict = {
  @warning("-27")
  let delete = (dict: Js.Dict.t<'a>, key: string): unit => %raw(`delete dict[key]`)

  @val external values: Js.Dict.t<'a> => array<'a> = "Object.values"
}

module JsArray = {
  @send external pop: Js.Array.t<'a> => 'a = "pop"
}

module Map = {
  type t<'key, 'value>
  @new external make: unit => t<'key, 'value> = "Map"
  @send external get: (t<'key, 'value>, 'key) => option<'value> = "get"
  @send external unsafeGet: (t<'key, 'value>, 'key) => 'value = "get"
  @send external set: (t<'key, 'value>, 'key, 'value) => unit = "set"
}

external \"!!": option<'a> => 'a = "%identity"
