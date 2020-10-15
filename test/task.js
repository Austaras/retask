import { andThen, sleep } from '..'

jest.useFakeTimers()

test('simple command could work', () => {
    const cb = jest.fn(_ => {})
    andThen(_ => sleep(200), sleep(300))(cb)
    const cancel = andThen(_ => sleep(200), sleep(300))(cb)
    andThen(_ => sleep(100), andThen(_ => sleep(200), sleep(300)))(cb)
    jest.runTimersToTime(100)
    expect(cb).toBeCalledTimes(0)
    cancel()
    jest.runTimersToTime(400)
    expect(cb).toBeCalledTimes(1)
    jest.runTimersToTime(100)
    expect(cb).toBeCalledTimes(2)
})
