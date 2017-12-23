REBOL [
  Title: {Day 23}
  Date: 23-12-2017
]

data: load %data/23.txt

; --- Part 1 ---
cpu: context [
  count: 0 regs: copy []
  ip: steps: bind collect [
    add-reg: func [reg [integer! word! block!]] [
      reg: to-block reg
      forall reg [
        if (type? reg/1) == word! [insert regs to-set-word reg/1]
      ]
    ]
    parse data [
      some [
        [ 'set set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) (y) ip: next ip])
        | 'sub set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) (x) - (y) ip: next ip])
        | 'mul set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) (x) * (y) count: count + 1 ip: next ip])
        | 'jnz set x [word! | integer!] set y [word! | integer!] (add-reg x keep/only compose/deep [either (x) != 0 [ip: skip ip (y)] [ip: next ip]])
        ]
      ]
    ]
  ] regs: context init: [a: b: c: d: e: f: g: h: 0]
  reset: does [ip: steps bind steps regs: context init count: 0]
  run: does [
    reset
    until [
      do ip/1
      tail? ip
    ]
    to-integer count
  ]
]
r1: cpu/run
print [{Part 1:} r1]

; --- Part 2 ---
; Naive REBOL translation of the code executed on the CPU when a=1 (cf. data/23.txt)
; h: 0 for b 106500 123500 17 [
;   f: 1 d: 2
;   until [
;     e: 2
;     until [
;       if b = (d * e) [f: 0]
;       b != (e: e + 1)
;     ]
;     b != (d: d + 1)
;   ]
;   all [f = 0 h: h + 1] ; h -> number of non-prime values between 106500 & 123500 taken at an interval of 17
; ]
debug-cpu: context [
  run: funct [] [
    prime?: func [value [integer!]] [
      all [0 = (value // 2) value > 2 return false]
      for i 3 to-integer round/down square-root value 2 [
        all [0 = (value // i) return false]
      ]
      true
    ]
    count: 0
    for value 106500 123500 17 [
      any [prime? value count: count + 1]
    ]
    count
  ]
]

r2: debug-cpu/run
print [{Part 2:} r2]
