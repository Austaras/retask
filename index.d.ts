export interface ReducerConfig<Model, Message> {
    init: [Model, Cmd<Message>]
    update: (model: Model, msg: Message) => [Model, Cmd<Message>]
    sub: (model: Model) => Sub
}

export function useReducerT<Model, Message>(
    config: ReducerConfig<Model, Message>
): [Model, (action: Message) => void]

export type Cmd<T> = () => void
export function noCmd<T>(): void
export function batchCmd<T>(cmds: Cmd<T>[]): Cmd<T>

export type Result<Ok, Err> = { TAG: 0; _0: Ok } | { TAG: 1; _0: Err }
export type Task<Ok, Err> = (callback: (payload: Result<Ok, Err>) => void) => () => void
export function performTask<Data, Message>(tagger: (data: Data) => Message, task: Task<Data, void>): void
export function attemptTask<Ok, Err, Message>(
    tagger: (data: Result<Ok, Err>) => Message,
    task: Task<Ok, Err>
): void
export function thenTask<T, U, Err>(mapper: (data: T) => Task<U, Err>, task: Task<T, Err>): Task<U, Err>
export function mapTask<T, U, Err>(mapper: (data: T) => U, task: Task<T, Err>): Task<U, Err>
export function mapTask2<T, U, R, Err>(
    mapper: (first: T, second: U) => R,
    task1: Task<T, Err>,
    task2: Task<U, Err>
): Task<R, Err>

export type Sub<T> = () => void
export function noSub(): void
export function batchSub<T>(subs: Sub<T>[]): void

export function delay<T>(time: number, tagger: () => T): Cmd<T>
export function sleep(time: number): Task<void, void>
export function everyTime(time: number, tagger: () => T): Sub<T>

export function onUniqueTarget<T>(element: EventTarget, event: string, tagger: (ev: Event) => T): Sub<T>
export function onDocument<T, K extends keyof DocumentEventMap>(
    event: K,
    tagger: (ev: DocumentEventMap[K]) => T
): Sub<T>
export function onDocument<T>(event: string, tagger: (ev: Event) => T): Sub<T>
export function onWindow<T, K extends keyof WindowEventMap>(
    event: K,
    tagger: (ev: WindowEventMap[K]) => T
): Sub<T>
export function onDocument<T>(event: string, tagger: (ev: Event) => T): Sub<T>

export function onWs<T>(ws: WebSocket, tagger: (ev: WebSocketEventMap['message']) => T): Sub<T>
export function onWsUrl<T>(url: string, tagger: (ev: WebSocketEventMap['message']) => T): Sub<T>
export function sendMessgae(ws: WebSocket, msg: string): Cmd<t>
export function sendMessageToUrl(url: string, msg: string): Cmd<t>
