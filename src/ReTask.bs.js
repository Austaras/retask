// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Util$Retask from "./util.bs.js";

function useReducerT(config) {
  var cancel = React.useRef({
        queue: {},
        id: 0
      });
  var partial_arg = config.update;
  var match = React.useReducer(Curry.__2(partial_arg), config.init);
  var res = match[0];
  var cmd = res[1];
  var dispatch = match[1];
  React.useEffect((function () {
          var makeRegister = function (param) {
            var id = String(cancel.current.id);
            cancel.current.id = cancel.current.id + 1 | 0;
            return [
                    (function (action) {
                        dispatch(action);
                        return Util$Retask.Dict.$$delete(cancel.current.queue, id);
                      }),
                    (function (cb) {
                        cancel.current.queue[id] = cb;
                        
                      })
                  ];
          };
          cmd(makeRegister);
          
        }), [res]);
  React.useEffect((function () {
          return (function (param) {
                    Object.values(cancel.current.queue).forEach(function (f) {
                          return Curry._1(f, undefined);
                        });
                    
                  });
        }), []);
  return [
          res[0],
          dispatch
        ];
}

export {
  useReducerT ,
  
}
/* react Not a pure module */
