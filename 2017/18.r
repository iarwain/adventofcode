REBOL [
  Title: {Day 18}
  Date: 18-12-2017
]

{!! This one would require REBOL 3 if we wanted to use integer! instead, due to the 32bit signed integer limitation of REBOL 2}

data: load %data/18.txt

; --- Part 1 ---
duet: context [
  play: recover: 0.0
  regs: copy []
  ip: steps: bind collect [
    add-reg: func [reg [integer! word! block!]] [
      reg: to-block reg
      forall reg [
        if (type? reg/1) == word! [insert regs to-set-word reg/1]
      ]
    ]
    parse data [
      some [
        [ 'snd set x [word! | integer!] (keep/only compose [play: to-decimal (x) ip: next ip])
        | 'set set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) to-decimal (y) ip: next ip])
        | 'add set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) (x) + to-decimal (y) ip: next ip])
        | 'mul set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) (x) * to-decimal (y) ip: next ip])
        | 'mod set x word! set y [word! | integer!] (add-reg reduce [x y] keep/only compose [(to-set-word x) mod (x) to-decimal (y) ip: next ip])
        | 'rcv set x [word!] (add-reg x keep/only compose [if (x) != 0.0 [recover: play] ip: next ip])
        | 'jgz set x [word! | integer!] set y [word! | integer!] (add-reg x keep/only compose/deep [either (x) > 0.0 [ip: skip ip (y)] [ip: next ip]])
        ]
      ]
    ]
  ] regs: context append sort unique regs 0.0
  reset: does [play: recover: 0.0 ip: steps foreach reg words-of regs [set reg 0.0]]
  run: does [
    reset
    until [
      do ip/1
      recover != 0.0
    ]
    to-integer recover
  ]
]

r1: duet/run
print [{Part 1:} r1]

; --- Part 2 ---
duets: context [
  current-id: -1 lock: 0 programs: none
  get-id: does [current-id: current-id + 1]
  program-spec: [
    id: get-id regs: copy [] queue: copy [] send-count: 0
    send: func [value [word! decimal!]] [
      append get in pick programs 2 - id 'queue value
      send-count: send-count + 1 lock: 0
    ]
    receive: func [reg [word!]] [
      either empty? queue [
        lock: lock + 1
        false
      ] [
        set in regs reg take queue
        true
      ]
    ]
    ip: steps: bind collect [
      add-reg: func [reg [integer! word! block!]] [
        reg: to-block reg
        forall reg [
          if (type? reg/1) == word! [insert regs to-set-word reg/1]
        ]
      ]
      parse data [
        some [
          [ 'snd set x [word! | integer!] (add-reg x keep/only compose [send to-decimal (x) ip: next ip])
          | 'set set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) to-decimal (y) ip: next ip])
          | 'add set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) (x) + to-decimal (y) ip: next ip])
          | 'mul set x word! set y [word! | integer!] (add-reg x keep/only compose [(to-set-word x) (x) * to-decimal (y) ip: next ip])
          | 'mod set x word! set y [word! | integer!] (add-reg reduce [x y] keep/only compose [(to-set-word x) mod (x) to-decimal (y) ip: next ip])
          | 'rcv set x word! (add-reg x keep/only compose [if receive (to-lit-word x) [ip: next ip]])
          | 'jgz set x [word! | integer!] set y [word! | integer!] (add-reg x keep/only compose/deep [either (x) > 0.0 [ip: skip ip (y)] [ip: next ip]])
          ]
        ]
      ]
    ] regs: context append sort unique regs 0.0
    regs/p: to-decimal id
  ]
  reset: does [current-id: -1 programs: collect [loop 2 [keep context program-spec]]]
  run: has [old-lock] [
    reset
    until [
      foreach program programs [
        until [
          old-lock: duets/lock
          do program/ip/1
          any [
            old-lock < duets/lock
            tail? program/ip
          ]
        ]
      ]
      any [
        duets/lock > 1
        tail? programs/1/ip
        tail? programs/2/ip
      ]
    ]
    programs/2/send-count
  ]
]

r2: duets/run
print [{Part 2:} r2]
