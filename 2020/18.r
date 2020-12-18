REBOL [
  Title: {Day 18}
  Date: 18-12-2020
]

; This one needs Rebol3-core in order to do integer operations on 64 bits.
data: read/lines %data/18.txt

; --- Part 1 ---
r1: 0 foreach result map-each line data [do line] [r1: r1 + result]
print [{Part 1:} r1]

; --- Part 2 ---
interpret: funct [expression] [
  eval: funct [expression] [
    attempt [return load expression]
    retval: copy [] depth: 0 sub: copy {}
    other: [copy char [{(} (depth: depth + 1) | {)} (depth: depth - 1) | skip] (append sub char)]
    parse expression [
      any [{*} (either depth > 0 [append sub {*}] [append insert retval 'multiply eval sub clear sub]) | other]
    ]
    if empty? retval [
      clear sub parse expression [
        any [{+} (either depth > 0 [append sub {+}] [append insert retval 'add eval sub clear sub]) | other]
      ]
    ]
    append retval either empty? retval [eval remove head remove back tail expression] [eval sub]
  ]
  do eval trim/all copy expression
]

r2: 0 foreach result map-each line data [interpret line] [r2: r2 + result]
print [{Part 2:} r2]
