REBOL [
  Title: {Day 16}
  Date: 16-12-2018
]

data: map-each line read/lines %data/16.txt [replace/all line {,} {}]

; --- Part 1 ---
device: context[
  multi-count: 0 run: none
  use [opcodes instructions program] [
    opcodes: array/initial 16 extract instructions: [
      addr [regs/(c + 1): regs/(a + 1) + regs/(b + 1)]
      addi [regs/(c + 1): regs/(a + 1) + b]
      mulr [regs/(c + 1): regs/(a + 1) * regs/(b + 1)]
      muli [regs/(c + 1): regs/(a + 1) * b]
      banr [regs/(c + 1): regs/(a + 1) and regs/(b + 1)]
      bani [regs/(c + 1): regs/(a + 1) and b]
      borr [regs/(c + 1): regs/(a + 1) or regs/(b + 1)]
      bori [regs/(c + 1): regs/(a + 1) or b]
      setr [regs/(c + 1): regs/(a + 1)]
      seti [regs/(c + 1): a]
      gtir [regs/(c + 1): pick [1 0] (a > regs/(b + 1))]
      gtri [regs/(c + 1): pick [1 0] (regs/(a + 1) > b)]
      gtrr [regs/(c + 1): pick [1 0] (regs/(a + 1) > regs/(b + 1))]
      eqir [regs/(c + 1): pick [1 0] (a = regs/(b + 1))]
      eqri [regs/(c + 1): pick [1 0] (regs/(a + 1) = b)]
      eqrr [regs/(c + 1): pick [1 0] (regs/(a + 1) = regs/(b + 1))]
    ] 2
    use [analyze regs op a b c result] [
      analyze: has [backup ops] [
        backup: copy regs
        ops: collect [
          foreach [opcode instruction] instructions [
            regs: copy backup
            do bind instruction 'regs
            all [regs = result keep opcode]
          ]
        ]
        opcodes/(op + 1): intersect opcodes/(op + 1) ops
        length? ops
      ]
      program: copy []
      foreach line data [
        parse line [
          [ {Before:} copy regs to end (regs: load regs)
          | {After:} copy result to end (clear back tail program result: load result all [analyze >= 3 multi-count: multi-count + 1])
          | copy op 4 integer! (repend/only program set [op a b c] load op)
          ]
        ]
      ]
      until [
        use [max-length others] [
          max-length: 0
          1 = forall opcodes [
            if 1 = length? opcodes/1 [
              others: head opcodes forall others [
                all [others != opcodes others/1: exclude others/1 opcodes/1]
              ]
            ]
            max-length: max max-length length? opcodes/1
          ]
        ]
      ]
    ]
    run: has [op a b c regs] [
      regs: copy [0 0 0 0]
      foreach step program [
        set [op a b c] step
        do bind instructions/(opcodes/(op + 1)/1) 'regs
      ]
      regs/1
    ]
  ]
]
r1: device/multi-count
print [{Part 1:} r1]

; --- Part 2 ---
r2: device/run
print [{Part 2:} r2]
