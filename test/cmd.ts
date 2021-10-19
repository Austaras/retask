/**
 * @jest-environment jsdom
 */

import { renderHook, act } from '@testing-library/react-hooks'

import { useReducerT, noCmd, batchCmd, noSub, delay, Cmd } from '..'

jest.useFakeTimers()

test('simple command could work', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, delay(10, () => true)],
      update: (state, act) => [act ? state + 1 : state - 1, noCmd],
      sub: _ => noSub
    })
  )

  act(() => result.current[1](false))
  act(() => {
    jest.runAllTimers()
  })
  expect(result.current[0]).toBe(0)
})

test('recursive command could work', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, delay(10, () => 0)],
      update: (state, _) => [state + 1, delay(10, () => 0)],
      sub: _ => noSub
    })
  )

  act(() => {
    jest.runOnlyPendingTimers()
  })
  act(() => {
    jest.runOnlyPendingTimers()
  })
  act(() => {
    jest.runOnlyPendingTimers()
  })
  expect(result.current[0]).toBe(3)
})

test('batch command could work', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, delay(10, () => 0)],
      update: (state, _) => [state + 1, batchCmd([delay(10, () => 0), delay(100, () => 0)])],
      sub: _ => noSub
    })
  )

  act(() => {
    jest.runOnlyPendingTimers()
  })
  act(() => {
    jest.runOnlyPendingTimers()
  })
  expect(result.current[0]).toBe(1 + 9 + 1)
})

test('command could run concurrently', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, delay(10, () => 0)],
      update: (state, _) => [state + 1, delay(10, () => 0)],
      sub: _ => noSub
    })
  )

  const { result: another } = renderHook(() =>
    useReducerT({
      init: [0, delay(100, () => 0)],
      update: (state, _) => [state + 1, noCmd],
      sub: _ => noSub
    })
  )

  act(() => {
    jest.advanceTimersByTime(100)
  })
  // due to precision
  expect(result.current[0]).toBe(9)
  expect(another.current[0]).toBe(1)
})

test('teardown logic could work', () => {
  const update = jest.fn((state: number) => [state + 1, noCmd] as [number, Cmd<void>])
  const { rerender, unmount } = renderHook(() =>
    useReducerT({
      init: [0, delay(10, () => 0)],
      update,
      sub: _ => noSub
    })
  )

  rerender()
  unmount()
  act(() => {
    jest.runAllTimers()
  })
  expect(update).not.toBeCalled()
})
