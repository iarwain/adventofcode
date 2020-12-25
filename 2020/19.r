REBOL [
  Title: {Day 19}
  Date: 19-12-2020
]

data: read %data/19.txt

; --- Part 1 ---
digit: charset "0123456789" number: [some digit] rules: copy {}
parse/all copy/part data data-end: find data {^/^/} [
  some [
    copy rule number (append rules join {rule-} rule)
  | {:} (append rules {: [})
  | newline (append rules { ]^/})
  | end (append rules { ]^/}) skip
  | copy char skip (append rules char)
  ]
]
messages: parse data-end {^/}
rules: context load rules
r1: length? remove-each message copy messages [not parse message rules/rule-0]
print [{Part 1:} r1]

; --- Part 2 ---
; Simply replacing the following rules won't work:
; rule-8: [rule-42 | rule-42 rule-8]
; rule-11: [rule-42 rule-31 | rule-42 rule-11 rule-31]
; When an early set of rules matches, there's no backtracking to its alternate version if a later rule fails to match
; We could to do this the hard (but correct) way...
; ... or simply brute-force it by combining all variants up to a length of 10, which is long enough for our inputs
brute-length: 10
all-rules: collect [
  foreach set collect [
    repeat i brute-length [keep make rules [rule-8: array/initial i 'rule-42]]
  ] [
    repeat i brute-length [keep make set [rule-11: append array/initial i 'rule-42 array/initial i 'rule-31]]
  ]
]
r2: length? remove-each message copy messages [not foreach rules all-rules [if parse message rules/rule-0 [break/return true]]]
print [{Part 2:} r2]
