REBOL [
  Title: {Day 7}
  Date: 31-01-2018
]

data: load replace/all read %data/7.txt {->} {--}

; --- Part 1 ---
power-on: funct [] [
  wires: collect [
    parse data [
      some [
        thru '-- set wire word! (keep reduce [wire 0])
      ]
    ]
  ]
  until [
    previous: copy wires
    parse data [
      some [
        [ set op 'NOT [set op1 integer! | set op1 word! (op1: wires/:op1)] '--
        | [set op1 integer! | set op1 word! (op1: wires/:op1)] [set op '-- | set op word! [set op2 integer! | set op2 word! (op2: wires/:op2)] '--]
        ] set wire word!
        (
          wires/:wire: switch op [
            --      [op1]
            NOT     [complement op1]
            AND     [op1 and op2]
            OR      [op1 or op2]
            LSHIFT  [65535 and shift/left op1 op2]
            RSHIFT  [shift op1 op2]
          ]
        )
      ]
    ]
    wires = previous
  ]
  wires/a
]
r1: power-on
print [{Part 1:} r1]

; --- Part 2 ---
change back find data [-- b] r1
r2: power-on
print [{Part 2:} r2]
