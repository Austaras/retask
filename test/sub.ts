import { renderHook, act } from '@testing-library/react-hooks'

import { useReducerT, noCmd, batchSub, noSub, everyTime, delay, Cmd } from '..'

jest.useFakeTimers()

test('sub should work', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, noCmd],
      update: (state, _) => [state + 1, noCmd],
      sub: model => (model < 10 ? everyTime(10, () => 0) : noSub)
    })
  )

  act(() => {
    jest.runAllTimers()
  })
  expect(result.current[0]).toBe(10)
})

test('batch should work', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, noCmd],
      update: (state, act: number) => [state + act, noCmd],
      sub: _ => batchSub([everyTime(10, () => 1), everyTime(100, () => -1)])
    })
  )

  act(() => {
    jest.advanceTimersByTime(150)
  })
  expect(result.current[0]).toBe(14)
})

test('tagger should work', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, delay(10, () => -1)],
      update: (state, act: boolean) => [state + +act, noCmd],
      sub: model => everyTime(10, (): boolean => model < 10)
    })
  )

  act(() => {
    jest.advanceTimersByTime(500)
  })
  expect(result.current[0]).toBe(10)
})

test('param should work', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, noCmd],
      update: (state, _) => [state + 1, noCmd],
      sub: model => everyTime(model < 10 ? 10 : 100, () => 1)
    })
  )

  act(() => {
    jest.advanceTimersByTime(100)
  })
  expect(result.current[0]).toBe(10)
  act(() => {
    jest.advanceTimersByTime(1000)
  })
  expect(result.current[0]).toBe(20)
})

test('should work concurrently', () => {
  const { result } = renderHook(() =>
    useReducerT({
      init: [0, noCmd],
      update: (state, _) => [state + 1, noCmd],
      sub: _ => everyTime(10, () => 1)
    })
  )

  const { result: another } = renderHook(() =>
    useReducerT({
      init: [0, noCmd],
      update: (state, _) => [state + 1, noCmd],
      sub: _ => everyTime(100, () => 1)
    })
  )

  act(() => {
    jest.advanceTimersByTime(100)
  })
  expect(result.current[0]).toBe(10)
  expect(another.current[0]).toBe(1)
})

test('teardown logic should work', () => {
  let update = jest.fn((state, _) => [state + 1, noCmd] as [number, Cmd<void>])
  const { rerender, unmount } = renderHook(() =>
    useReducerT({
      init: [0, noCmd],
      update,
      sub: _ => everyTime(10, () => 0)
    })
  )

  rerender()
  unmount()
  act(() => {
    jest.runAllTimers()
  })
  expect(update).not.toBeCalled()
})
