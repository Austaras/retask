import { renderHook, act } from '@testing-library/react-hooks'
import { useReducerT } from '../src/ReTask.bs'
import { none } from '../src/cmd.bs'
import { none as noSub } from '../src/sub.bs'

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
