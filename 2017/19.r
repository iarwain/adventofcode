REBOL [
  Title: {Day 19}
  Date: 19-12-2017
]

data: read %data/19.txt

; --- Part 1 ---
diagram: context [
  grid: make hash! collect [
    use [pos letters] [
      pos: 1x1 letters: charset [#"A" - #"Z"]
      parse/all data [
        some [
          [ { }
          | [{|} | {-}] (keep reduce [pos 'straight])
          | {+} (keep reduce [pos 'turn])
          | copy letter letters (keep reduce [pos letter])
          | newline (pos: pos * 0x1 + 0x1)
          ] (pos: pos + 1x0)
        ]
        end
      ]
    ]
  ]
  route: funct [] [
    length: length? dirs: [0x1 1x0 0x-1 -1x0]
    pos: grid/1 dir: 1 steps: 0 letters: copy {}
    while [value: select grid pos] [
      switch/default value [
        straight []
        turn [
          test: add mod dir - 2 length 1
          dir: either find grid pos + dirs/:test [test] [add mod dir length 1]
        ]
      ] [append letters value]
      pos: pos + dirs/:dir steps: steps + 1
    ]
    reduce [letters steps]
  ]
]

set [r1 r2] diagram/route

print [{Part 1:} r1]

; --- Part 2 ---
print [{Part 2:} r2]
