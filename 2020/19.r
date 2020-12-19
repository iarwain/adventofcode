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
  | copy char skip (append rules char)
  ]
]
do append rules { ]}
messages: parse data-end {^/}

r1: length? remove-each message copy messages [not parse message rule-0]
print [{Part 1:} r1]

; --- Part 2 ---
; Simply replacing the following rules won't work:
rule-8: [rule-42 | rule-42 rule-8]
rule-11: [rule-42 rule-31 | rule-42 rule-11 rule-31]
; When an early set of rules matches, there's no backtracking to its alternate version if a later rule fails to match
; Need to do this the hard way...
; Code to be cleaned & translated from the C version at some point, but not tonight!

; --- Clean up to come ---
r2: length? remove-each message copy messages [not parse message rule-0]
print [{Part 2:} r2]
