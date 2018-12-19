REBOL [
  Title: {Day 19}
  Date: 19-12-2018
]

data: read/lines %data/19.txt

; --- Part 1 ---
device: context[
  switch: run: none
  use [instructions init program binding regs a b c] [
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
            [ {#ip} copy binding integer! (binding: 1 + load binding)
            | copy op to { } copy regs 3 integer! (keep/only append reduce [load op] load regs)
            ]
          ]
        ]
      ]
    ]
    switch: does [init/1: 1 - init/1]
    run: has [ip op sum n] [
      regs: copy init ip: 0
      until [
        set [op a b c] program/(ip + 1)
        regs/:binding: ip
        do instructions/:op
        ;print ["ip:" ip "|" op a b c mold regs "-> ip:" ip: regs/:binding + 1]
        1 = ip: regs/:binding + 1 ; Init phase is complete when IP = 1
      ]
      ; Compute the sum of factors of regs/4 (found by checking the head/tail of the logs and the result of phase 1 in full simulation mode)
      sum: 0 n: 1
      until [
        all [0 = (regs/4 // n) sum: sum + n]
        (n: n + 1) > regs/4
      ]
      sum
    ]
  ]
]
r1: device/run
print [{Part 1:} r1]

; --- Part 2 ---
device/switch
r2: device/run
print [{Part 2:} r2]
