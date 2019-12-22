REBOL [
  Title: {Day 22}
  Date: 22-12-2019
]

; This one needs Rebol3 (Ren-C) in order to be able to do integer operations on 64 bits.
data: read/lines %data/22.txt

; --- Part 1 ---
cards: context [
  shuffle: func [card /locate <local> deck index length temp size mod-inv mod-mul exponentiate cycles factor offset] [
    either locate [
      deck: collect [repeat i size: 10007 [keep i - 1]]
      for-each line data [
        parse line [
          "deal into new stack" (
            reverse deck
          )
        | "deal with increment" copy length to end (
            index: 1 length: load length
            temp: array size
            for-each card deck [
              temp/:index: card
              if size < index: (index + length) [index: index - size]
            ]
            deck: temp
          )
        | "cut" copy length to end (
            append deck take/part deck either positive? length: load length [length] [length + size]
          )
        ]
      ]
      (index? find deck card) - 1
    ] [
      mod-inv: func [value size <local> t nt r nr q] [
        t: 0 nt: 1 r: size nr: value
        until [
          q: to-integer r / nr
          set [t nt] reduce [nt t - (q * nt)]
          set [r nr] reduce [nr r - (q * nr)]
          nr = 0
        ]
        t mod size
      ]
      mod-mul: func [a b size <local> res] [
        a: a mod size res: 0
        until [
          if odd? b [res: (res + a) mod size]
          a: (2 * a) mod size
          b: to-integer b / 2
          b = 0
        ]
        res
      ]
      exponentiate: func [value exp <local> square res] [
        case [
          exp = 0   [[1 0]]
          exp = 1   [value]
          true      [
            square: reduce [mod-mul value/1 value/1 size (value/2 + mod-mul value/1 value/2 size) mod size]
            res: exponentiate square to-integer exp / 2
            if odd? exp [
              res: reduce [mod-mul value/1 res/1 size (res/2 + mod-mul res/1 value/2 size) mod size]
            ]
            res
          ]
        ]
      ]
      size: 119315717514047 cycles: 101741582076661
      factor: 1 offset: 0
      ; Going backward
      for-each line copy reverse data [
        parse line [
          [ "deal into new stack" (
              ; We want [card: size - 1 - card]
              offset: negate offset + 1
              factor: negate factor
            )
          | "deal with increment" copy length to end (
              ; We want [card: (card * power length (size - 2)) mod size]
              ; We need helpers to prevent math overflows
              pow: mod-inv load length size
              factor: mod-mul factor pow size
              offset: mod-mul offset pow size
            )
          | "cut" copy length to end (
              ; We want [card: (card - length) mod size]
              offset: offset + load length
          )
          ]
        ] (
          factor: factor mod size offset: offset mod size
        )
      ]
      set [factor offset] exponentiate reduce [factor offset] cycles
      factor * card + offset mod size
    ]
  ]
]

r1: cards/shuffle/locate 2019
print [{Part 1:} r1]

; --- Part 2 ---

r2: cards/shuffle 2020
print [{Part 1:} r2]
