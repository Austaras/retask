import { renderHook, act } from '@testing-library/react-hooks'

import { useReducerT, noCmd, noSub } from '..'

test('can be used as a normal useReducer', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, noCmd],
            update: (state, act) => [act ? state + 1 : state - 1, noCmd],
            sub: _ => noSub
        })
    )

    act(() => {
        result.current[1](true)
        result.current[1](true)
    })
    expect(result.current[0]).toBe(2)

    act(() => {
        result.current[1](false)
        result.current[1](true)
    })
    expect(result.current[0]).toBe(2)
})
