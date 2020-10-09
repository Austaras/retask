import { renderHook, act } from '@testing-library/react-hooks'
import { useReducerT } from '../lib/es6/src/ReTask'
import { none } from '../lib/es6/src/cmd'
import { none as noSub } from '../lib/es6/src/sub'

test('can be used as a normal useReducer', () => {
    const { result } = renderHook(() =>
        useReducerT({
            init: [0, none],
            update: (state, act) => [act ? state + 1 : state - 1, none],
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
