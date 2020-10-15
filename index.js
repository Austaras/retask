export { useReducerT, make as TaskComponent } from './lib/es6/src/ReTask'

export { none as noCmd, batch as batchCmd } from './lib/es6/src/cmd'
export { perform, andThen } from './lib/es6/src/task'
export { none as noSub, batch as batchSub } from './lib/es6/src/sub'

export { every, delay, sleep } from './lib/es6/src/time'
export { on as onDocument } from './lib/es6/src/document'
export {
    on as onWs,
    onUrl as onWsUrl,
    send as sendMessage,
    sendUrl as sendMessageToUrl
} from './lib/es6/src/ws'
