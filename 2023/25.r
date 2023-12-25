REBOL [
  Title: {Day 25}
  Date: 25-12-2023
]

data: read/lines %data/25.txt

; --- Part 1 ---
; I used Graphviz/Dot to visualize the graph and found the 3 links to cut visually.
; If I get enough motivation, I might try to implement the Stoer-Wagner algorithm in Rebol and see if it's not too slow.
; https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm (minimum cut)
r1: 554064 ; 776 * 714
print [{Part 1:} r1]

; --- Part 2 ---
r2: {There's no part 2! :-)}
print [{Part 2:} r2]
