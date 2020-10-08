external any_cast: 'a => 'b = "%identity";

module Dict = {
  let delete = (_dict: Js.Dict.t('a), _key: string): unit => [%raw {js|delete dict[key]|js}];

  [@bs.val] external values: Js.Dict.t('a) => array('a) = "Object.values";
};

module JsArray = {
  [@bs.send] external pop: Js.Array.t('a) => 'a = "pop";
};
