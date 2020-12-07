REBOL [
  Title: {Day 7}
  Date: 07-12-2020
]

data: read/lines %data/7.txt

; --- Part 1 ---
bags: collect [
  digit: charset "012345679"
  foreach line data [
    children: copy []
    parse line [
      copy source to {bags} (source: trim source) thru {contain}
      some [
        copy count some digit
        copy child to {bag}
        (append children reduce [trim child load count])
        opt thru {,}
      ]
    ]
    keep reduce [source children]
  ]
]
check: [{shiny gold}]
until [
  foreach [bag children] bags [
    all [
      find children check/1
      not find head check bag
      append check bag
    ]
  ]
  tail? check: next check
]
r1: length? next head check
print [{Part 1:} r1]

; --- Part 2 ---
r2: do count-bags: funct [bag] [
  result: 0 children: bags/:bag
  foreach [child count] children [
    result: result + count + (count * count-bags child)
  ]
  result
] {shiny gold}
print [{Part 2:} r2]
