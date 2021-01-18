open Webapi.Dom

module MessageEvent = {
  type t = {
    data: string,
    origin: string,
    lastEventId: string,
  }

  include Event.Impl({
    type t = t
  })
}

module CloseEvent = {
  type rec code =
    | NormalClosure
    | GoingAway
    | ProtocolError
    | UnsupportedData
    | Empty_
    | NoStatus
    | AbnormalClosure
    | InvalidFramePayload
    | PolicyViolation
    | MessageTooBig
    | MissingExtension
    | InternalError
    | ServiceRestart
    | TryAgainLater
    | BadGateway
    | TLSHandshake
    | CustomCode(int, t)
  and t = {
    code: int,
    reason: string,
    wasClean: bool,
  }

  include Event.Impl({
    type t = t
  })

  let code = ev =>
    switch ev.code {
    | 1000 => NormalClosure
    | 1001 => GoingAway
    | 1002 => ProtocolError
    | 1003 => UnsupportedData
    | 1004 => Empty_
    | 1005 => NoStatus
    | 1006 => AbnormalClosure
    | 1007 => InvalidFramePayload
    | 1008 => PolicyViolation
    | 1009 => MessageTooBig
    | 1010 => MissingExtension
    | 1011 => InternalError
    | 1012 => ServiceRestart
    | 1013 => TryAgainLater
    | 1014 => BadGateway
    | 1015 => TLSHandshake
    | n => CustomCode(n, ev)
    }
}

exception UnknownReadyState(int)

type readyState =
  | Connecting
  | Open
  | Closing
  | Closed

type protocols = array<string>

type t = {
  mutable binaryType: [#Blob | #ArrayBuffer],
  mutable onopen: MessageEvent.t => unit,
  mutable onerror: MessageEvent.t => unit,
  mutable onclose: CloseEvent.t => unit,
  mutable onmessage: MessageEvent.t => unit,
  bufferedAmount: int,
  url: string,
  protocol: string,
  readyState: readyState,
  extensions: string,
  close: (. unit) => unit,
  send: (. string) => unit,
}

@bs.new external make: string => t = "WebSocket"

@bs.new external withProtocol: (string, protocols) => t = "WebSocket"
@bs.send
external addEventListener: (
  t,
  @bs.string
  [
    | @bs.as("open") #open_(MessageEvent.t => unit)
    | #close(CloseEvent.t => unit)
    | #message(MessageEvent.t => unit)
  ],
) => unit = "addEventListener"
@bs.send
external removeEventListener: (
  t,
  @bs.string
  [
    | @bs.as("open") #open_(MessageEvent.t => unit)
    | #close(CloseEvent.t => unit)
    | #message(MessageEvent.t => unit)
  ],
) => unit = "removeEventListener"
