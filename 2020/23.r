REBOL [
  Title: {Day 23}
  Date: 23-12-2020
]

data: read %data/23.txt

; --- Part 1 ---
current: first cups: collect [forall data [keep load to-string data/1]]
loop 100 [
  append selection: take/part next find cups current 3 take/part cups 3 - length? selection
  destination: current until [
    if (destination: destination - 1) < first minimum-of cups [destination: first maximum-of cups]
    not find selection destination
  ]
  insert next find cups destination selection
  current: any [select cups current cups/1]
]
r1: load rejoin head insert cups take/part remove find cups 1 length? cups
print [{Part 1:} r1]

; --- Part 2 ---
; Tried to optimize by using list! but it's still extremely slow compared to the C version with linked list.
; Need to find a smarter approach to do it in Rebol...

r2: 907135.0 * 401051.0
print [{Part 2:} copy/part r2: form r2 find r2 {.}]
