import { act, renderHook } from '@testing-library/react-hooks'

import { noCmd, onDocument, useReducerT } from '..'

test('could click', () => {
    const { result, unmount } = renderHook(() =>
        useReducerT({
            init: [0, noCmd],
            update: (state, _) => [state + 1, noCmd],
            sub: _ => onDocument('click', _ => true)
        })
    )

    act(() => document.body.click())
    expect(result.current[0]).toBe(1)

    unmount()

    act(() => document.body.click())
    expect(result.current[0]).toBe(1)
})
