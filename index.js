export { useReducerT, make as TaskComponent } from './lib/es6/src/ReTask'

export { none as noCmd, batch as batchCmd } from './lib/es6/src/cmd'
export {
    perform as performTask,
    attempt as attemptTask,
    andThen as thenTask,
    map as mapTask,
    map2 as mapTask2
} from './lib/es6/src/task'
export { none as noSub, batch as batchSub } from './lib/es6/src/sub'

export { every as everyTime, delay, sleep } from './lib/es6/src/time'
export { onDocument, onWindow, onUniqueTarget } from './lib/es6/src/domEvent'
export {
    on as onWs,
    onUrl as onWsUrl,
    send as sendMessage,
    sendUrl as sendMessageToUrl
} from './lib/es6/src/ws'
