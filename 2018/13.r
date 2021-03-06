REBOL [
  Title: {Day 13}
  Date: 13-12-2018
]

data: read/lines %data/13.txt

; --- Part 1 ---
race: context [
  track: copy/deep data run: none
  use [directions moves left up right down size] [
    directions: next reduce [left: #"<" up: #"^^" right: #">" down: #"v" left up]
    size: length? track/1 moves: reduce [left -1x0 up 0x-1 right 1x0 down 0x1]
    run: funct [/first-crash] [
      carts: collect [
        forall track [
          line: track/1 forall line [
            all [
              find directions line/1
              keep context [pos: as-pair index? line index? track dir: line/1 turn: 0 destroyed: false]
            ]
          ]
        ]
      ]
      until [
        foreach cart sort/compare carts func [a b] [(a/pos/y * size + a/pos/x) < (b/pos/y * size + b/pos/x)] [
          unless cart/destroyed [
            cart/pos: cart/pos + moves/(cart/dir)
            switch track/(cart/pos/y)/(cart/pos/x) [
              #"+" [
                cart/dir: first skip find directions cart/dir cart/turn - 1
                cart/turn: (cart/turn + 1) // 3
              ]
              #"/" [cart/dir: first skip dir: find directions cart/dir pick [1 -1] even? index? dir]
              #"\" [cart/dir: first skip dir: find directions cart/dir pick [1 -1] odd? index? dir]
            ]
            current: carts forall current [
              foreach other next current [
                if other/pos = current/1/pos [
                  all [first-crash carts: reduce [current/1] break]
                  other/destroyed: current/1/destroyed: true
                ]
              ]
            ]
          ]
        ]
        1 = length? remove-each cart carts [cart/destroyed]
      ]
      carts/1/pos - 1x1
    ]
  ]
]
r1: race/run/first-crash
print [{Part 1:} r1]

; --- Part 2 ---
r2: race/run
print [{Part 2:} r2]
