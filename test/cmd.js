import { renderHook, act } from '@testing-library/react-hooks'

import { useReducerT, noCmd, batchCmd, noSub ,delay } from '..'

jest.useFakeTimers()

test('simple command could work', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, delay(_ => true, 10)],
            update: (state, act) => [act ? state + 1 : state - 1, noCmd],
            sub: _ => noSub
        })
    )

    act(() => result.current[1](false))
    act(() => jest.runAllTimers())
    expect(result.current[0]).toBe(0)
})

test('recursive command could work', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, delay(_ => 0, 10)],
            update: (state, _) => [state + 1, delay(_ => 0, 10)],
            sub: _ => noSub
        })
    )

    act(() => jest.runOnlyPendingTimers())
    act(() => jest.runOnlyPendingTimers())
    act(() => jest.runOnlyPendingTimers())
    expect(result.current[0]).toBe(3)
})

test('batch command could work', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, delay(_ => 0, 10)],
            update: (state, _) => [state + 1, batchCmd([delay(_ => 0, 10), delay(_ => 0, 100)])],
            sub: _ => noSub
        })
    )

    act(() => jest.runOnlyPendingTimers())
    act(() => jest.runOnlyPendingTimers())
    act(() => jest.runOnlyPendingTimers())
    expect(result.current[0]).toBe(5)
})

test('command could run concurrently', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, delay(_ => 0, 10)],
            update: (state, _) => [state + 1, delay(_ => 0, 10)],
            sub: _ => noSub
        })
    )

    const { result: another } = renderHook(() =>
        useReducerT({
            init: [0, delay(_ => 0, 100)],
            update: (state, _) => [state + 1, noCmd],
            sub: _ => noSub
        })
    )

    act(() => jest.runTimersToTime(100))
    expect(result.current[0]).toBe(10)
    expect(another.current[0]).toBe(1)
})

test('teardown logic could work', () => {
    let update = jest.fn((state, _) => [state + 1, noCmd])
    const { rerender, unmount } = renderHook(() =>
        useReducerT({
            init: [0, delay(_ => 0, 10)],
            update,
            sub: _ => noSub
        })
    )

    rerender()
    unmount()
    act(() => jest.runAllTimers())
    expect(update).not.toBeCalled()
})
