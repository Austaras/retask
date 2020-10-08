// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE

import * as Diff from "./diff";

function register(param) {
  
}

function setReg(make) {
  return (register = make);
}

function none() {
  
}

function batch(subs) {
  return function () {
    subs.forEach(function (f) {
          return f();
        });
    
  };
}

function getToken(str) {
  return str.split(".")[0];
}

function sameSub(prim, prim$1, prim$2, prim$3) {
  return Diff.sameSub(prim, prim$1, prim$2, prim$3);
}

export {
  register ,
  setReg ,
  none ,
  batch ,
  getToken ,
  sameSub ,
  
}
/* ./diff Not a pure module */
