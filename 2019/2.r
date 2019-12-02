REBOL [
  Title: {Day 2}
  Date: 02-12-2019
]

data: load replace/all read %data/2.txt {,} { }

; --- Part 1 ---
compute: funct [noun verb] [
  instructions: [add multiply]
  memory: copy data memory/2: noun memory/3: verb
  use [inst op1 op2 dst] [
    parse memory [
      some [
        1 1 99 break
      | set inst integer! set op1 integer! set op2 integer! set dst integer! (
          memory/(dst + 1): do compose [(instructions/:inst) memory/(op1 + 1) memory/(op2 + 1)]
        )
      ]
    ]
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
        return reduce [i j]
      ]
    ]
  ]
]

r2: (100 * first r2: solve) + r2/2
print [{Part 2:} r2]
