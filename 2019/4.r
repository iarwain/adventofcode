REBOL [
  Title: {Day 4}
  Date: 04-12-2019
]

data: load replace/all read %data/4.txt {-} { }

; --- Part 1 ---
count-passwords: funct [low high /strict-group] [
  count: 0
  for value low high 1 [
    all [
      (value: mold value) = sort copy value
      do [
        streak: 0
        forall value [
          case [
            value/1 = value/-1  [streak: streak + 1 any [strict-group break]]
            streak = 2          [break]
            true                [streak: 1]
          ]
        ]
        streak = 2
      ]
      count: count + 1
    ]
  ]
  count
]
r1: count-passwords data/1 data/2
print [{Part 1:} r1]

; --- Part 2 ---
r2: count-passwords/strict-group data/1 data/2
print [{Part 2:} r2]
