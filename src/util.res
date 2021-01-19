@unboxed
type ret = {cancel: (. unit) => unit}

external any_cast: 'a => 'b = "%identity"

module Dict = {
  @warning("-27")
  let delete = (dict: Js.Dict.t<'a>, key: string): unit => %raw(`delete dict[key]`)

  @bs.val external values: Js.Dict.t<'a> => array<'a> = "Object.values"
}

module JsArray = {
  @bs.send external pop: Js.Array.t<'a> => 'a = "pop"
}

module Map = {
  type t<'key, 'value>
  @bs.new external make: unit => t<'key, 'value> = "Map"
  @bs.send external get: (t<'key, 'value>, 'key) => option<'value> = "get"
  @bs.send external unsafeGet: (t<'key, 'value>, 'key) => 'value = "get"
  @bs.send external set: (t<'key, 'value>, 'key, 'value) => unit = "set"
}

external \"!!": option<'a> => 'a = "%identity"
