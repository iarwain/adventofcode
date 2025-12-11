REBOL [
  Title: {Day 11}
  Date: 11-12-2025
]

data: read/lines %data/11.txt
racks: context [
  devices: copy []
  do function [] [
    letters: charset [#"a" - #"z"]
    foreach line data [
      parse line [
        copy device to {:} (append devices device outputs: copy [])
        some [
          copy device some letters (append outputs device)
        | skip
        ]
        (append/only devices outputs)
      ]
    ]
  ]
  paths?: function [device destination /recurse] [
    network: []
    unless recurse [clear network]
    case [
      device = destination [result: 1]
      none? result: select network device [
        result: 0
        foreach output select devices device [
          result: result + paths?/recurse output destination
        ]
        repend network [device result]
      ]
    ]
    result
  ]
]

; --- Part 1 ---
r1: racks/paths? {you} {out}
print [{Part 1:} r1]

; --- Part 2 ---
r2: ((racks/paths? {svr} {dac}) * (racks/paths? {dac} {fft}) * (racks/paths? {fft} {out}))
  + ((racks/paths? {svr} {fft}) * (racks/paths? {fft} {dac}) * (racks/paths? {dac} {out}))
print [{Part 2:} r2]
