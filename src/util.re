[@unboxed]
type result = {
  cancel: (. unit) => unit
}

external any_cast: 'a => 'b = "%identity";

module Dict = {
  [@warning "-27"]
  let delete = (dict: Js.Dict.t('a), key: string): unit => [%raw {js|delete dict[key]|js}];

  [@bs.val] external values: Js.Dict.t('a) => array('a) = "Object.values";
};

module JsArray = {
  [@bs.send] external pop: Js.Array.t('a) => 'a = "pop";
};

module Map = {
  type t('key, 'value);
  [@bs.new] external make: unit => t('key, 'value) = "Map"
  [@bs.send] external get: (t('key, 'value), 'key) => option('value) = "Map"
  [@bs.send] external unsafeGet: (t('key, 'value), 'key) => 'value = "Map"
  [@bs.send] external set: (t('key, 'value), 'key, 'value) => unit = "Map"
}

external (!!): option('a) => 'a = "%identity"
