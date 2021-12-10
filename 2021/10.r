REBOL [
  Title: {Day 10}
  Date: 10-12-2021
]

data: read/lines %data/10.txt

; --- Part 1 ---
navigation: context [
  error-score: complete-score: 0
  use [scores matches values stack score] [
    scores: sort collect [
      matches: [#")" #"(" #"]" #"[" #"}" #"{" #">" #"<"]
      values: [#"(" 1 #")" 3 #"[" 2 #"]" 57 #"{" 3 #"}" 1197 #"<" 4 #">" 25137]
      error-score: 0 foreach line data [
        stack: copy []
        foreach char line [
          switch char [
            #"(" #"[" #"{" #"<" [insert stack char]
            #")" #"]" #"}" #">" [unless matches/:char = take stack [error-score: error-score + values/:char clear stack break]]
          ]
        ]
        score: 0.0 all [score: foreach char stack [score: 5 * score + values/:char] keep score]
      ]
    ]
    complete-score: copy/part complete-score: to-string scores/((length? scores) / 2 + 1) find complete-score {.}
  ]
]

r1: navigation/error-score
print [{Part 1:} r1]

; --- Part 2 ---
r2: navigation/complete-score
print [{Part 2:} r2]
