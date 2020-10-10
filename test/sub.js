import { renderHook, act } from '@testing-library/react-hooks'
import { useReducerT } from '../lib/es6/src/ReTask'
import { none } from '../lib/es6/src/cmd'
import { batch } from '../lib/es6/src/sub'
import { every, delay } from '../lib/es6/src/time'

jest.useFakeTimers()

test('sub should work', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, none],
            update: (state, _) => [state + 1, none],
            sub: model => (model < 10 ? every(_ => 0, 10) : none)
        })
    )

    act(() => jest.runAllTimers())
    expect(result.current[0]).toBe(10)
})

test('batch should work', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, none],
            update: (state, act) => [state + act, none],
            sub: _ => batch([every(_ => 1, 10), every(_ => -1, 100)])
        })
    )

    act(() => jest.runTimersToTime(150))
    expect(result.current[0]).toBe(14)
})

test('tagger should work', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, delay(_ => false, 10)],
            update: (state, act) => [state + +act, none],
            sub: model => every(_ => model < 10, 10)
        })
    )

    act(() => jest.runTimersToTime(500))
    expect(result.current[0]).toBe(10)
})

test('param should work', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, none],
            update: (state, _) => [state + 1, none],
            sub: model => every(_ => 1, model < 10 ? 10 : 100)
        })
    )

    act(() => jest.runTimersToTime(100))
    expect(result.current[0]).toBe(10)
    act(() => jest.runTimersToTime(1000))
    expect(result.current[0]).toBe(20)
})

test('should work concurrently', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, none],
            update: (state, _) => [state + 1, none],
            sub: _ => every(_ => 1, 10)
        })
    )

    const { result: another } = renderHook(() =>
        useReducerT({
            init: [0, none],
            update: (state, _) => [state + 1, none],
            sub: _ => every(_ => 1, 100)
        })
    )

    act(() => jest.runTimersToTime(100))
    expect(result.current[0]).toBe(10)
    expect(another.current[0]).toBe(1)
})

test('teardown logic should work', () => {
    let update = jest.fn((state, _) => [state + 1, none])
    const { rerender, unmount } = renderHook(() =>
        useReducerT({
            init: [0, none],
            update,
            sub: _ => every(_ => 0, 10)
        })
    )

    rerender()
    unmount()
    act(() => jest.runAllTimers())
    expect(update).not.toBeCalled()
})
