REBOL [
  Title: {Day 3}
  Date: 03-12-2021
]

data: read/lines %data/3.txt

; --- Part 1 ---
ops: [lesser? greater-or-equal?]
count: funct [data] [
  values: array/initial 2 does [head insert/dup copy {} #"0" 16 - length? data/1]
  set 'counts copy []
  for i 1 length? data/1 1 [
    counter: 0
    foreach entry data [
      if #"1" == entry/:i [
        counter: counter + 1
      ]
    ]
    forall ops [
      append values/(index? ops) pick [#"0" #"1"] do ops/1 counter (length? data) / 2
    ]
    append counts counter
  ]
  map-each value values [to-integer debase/base value 2]
]

r1: count data
print [{Part 1:} r1/1 * r1/2]

; --- Part 2 ---
filter: funct [op] [
  data: copy system/words/data
  for i 1 length? data/1 1 [
    count data
    remove-each entry data [
      entry/:i == pick [#"0" #"1"] do op counts/:i (length? data) / 2
    ]
    if 1 == length? data [
      return head insert/dup copy data/1 #"0" 16 - length? data/1
    ]
  ]
]

r2: map-each op ops [
  to-integer debase/base filter op 2
]
print [{Part 2:} r2/1 * r2/2]
