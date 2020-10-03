external any_cast: 'a => 'b = "%identity";

type dispatch('a) = (. 'a) => unit;

type cancel = {
  queue: Js.Dict.t(unit => unit),
  mutable id: int,
};

type register('a) = (dispatch('a), (unit => unit) => unit);

type makeRegister('a) = unit => register('a);
