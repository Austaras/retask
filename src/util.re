external any_cast: 'a => 'b = "%identity";

module Dict = {
  [@warning "-27"]
  let delete = (dict: Js.Dict.t('a), key: string): unit => [%raw {js|delete dict[key]|js}];

  [@bs.val] external values: Js.Dict.t('a) => array('a) = "Object.values";
};

module JsArray = {
  [@bs.send] external pop: Js.Array.t('a) => 'a = "pop";
};
