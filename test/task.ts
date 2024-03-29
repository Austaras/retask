import { thenTask, sleep } from '..'

jest.useFakeTimers()

test('simple command could work', () => {
  const cb = jest.fn(_ => {})
  const getSleep = (time: number) => () => sleep(time)
  thenTask(getSleep(200), sleep(300))(cb)
  const cancel = thenTask(getSleep(200), sleep(300))(cb)
  thenTask(getSleep(100), thenTask(getSleep(200), sleep(300)))(cb)

  jest.advanceTimersByTime(100)
  expect(cb).toBeCalledTimes(0)
  cancel()
  jest.advanceTimersByTime(400)
  expect(cb).toBeCalledTimes(1)
  jest.advanceTimersByTime(100)
  expect(cb).toBeCalledTimes(2)
})
