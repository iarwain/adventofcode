REBOL [
  Title: {Day 21}
  Date: 21-12-2018
]

; This one needs Rebol3 in order to be able to do integer operations on 64 bits (mul, and, or, ...).
data: read/lines %data/21.txt

; --- Part 1 ---
; Simulation version: part 2 is insanely slow using that version.
device-sim: context[
  run: none program: binding: none
  use [instructions init regs a b c] [
    bind instructions: [
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
    ] 'regs
    init: copy [0 0 0 0 0 0]
    program: collect [
      use [op regs] [
        foreach line data [
          parse line [
            [ {#ip} copy binding to end (binding: 1 + load binding)
            | copy op to { } copy regs to end (keep/only append reduce [load op] load regs)
            ]
          ]
        ]
      ]
    ]
    run: func [/first-stop /local history ip op] [
      unless first-stop [history: copy []]
      regs: copy init ip: 0 it: 0
      forever [
        set [op a b c] program/(ip + 1)
        ; The program will test for the loop-exit condition on line 28 (it's the only place where it'll compare regs/1 (r0) with another register).
        if ip = 28 [
          probe it: it + 1
          case [
            first-stop [return regs/(a + 1)]
            find history regs/(a + 1) [return last history]
            true [append history regs/(a + 1)]
          ]
        ]
        regs/:binding: ip
        do instructions/:op
        ip: regs/:binding + 1
      ]
    ]
  ]
]
; Re-implemented version, results will be found within a second
device: context [
  shortest: longest: none
  use [history res check] [
    history: copy [] res: 0
    forever [
      check: res or 65536 res: second load data/9 ; Input-dependent: 7637914
      forever [
        res: (((res + (check and 255)) and 16777215) * 65899) and 16777215
        either check < 256 [break] [check: shift check -8]
      ]
      either find history res [break] [append history res]
    ]
    shortest: first history longest: last history
  ]
]
r1: device/shortest
print [{Part 1:} r1]

; --- Part 2 ---
r2: device/longest
print [{Part 2:} r2]
