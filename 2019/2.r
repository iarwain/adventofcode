REBOL [
  Title: {Day 2}
  Date: 02-12-2019
]

data: load replace/all read %data/2.txt {,} { }

; --- Part 1 ---
compute: func [noun verb /local instructions ip memory inst op1 op2 dst] [
  instructions: [add multiply] ip: memory: copy data memory/2: noun memory/3: verb
  while [ip/1 != 99] [
    set [inst op1 op2 dst] ip
    ip: skip ip 4
    memory/(dst + 1): do compose [(instructions/:inst) memory/(op1 + 1) memory/(op2 + 1)]
  ]
  memory/1
]

r1: compute 12 2
print [{Part 1:} r1]

; --- Part 2 ---
solve: does [
  for i 0 99 1 [
    for j 0 99 1 [
      if 19690720 = compute i j [
        return 100 * i + j
      ]
    ]
  ]
]

r2: solve
print [{Part 2:} r2]
