REBOL [
  Title: {Day 21}
  Date: 21-12-2020
]

data: read/lines %data/21.txt

; --- Part 1 ---
foods: collect [
  foreach line data [
    parse line [copy ingredients to {(} thru {contains} copy allergens to {)}]
    keep reduce [parse ingredients {} parse allergens {,}]
  ]
]
table: copy [] foreach [ingredients allergens] foods [
  foreach allergen allergens [
    either find table allergen [
      table/:allergen: intersect table/:allergen ingredients
    ] [
      append table reduce [allergen ingredients]
    ]
  ]
]
with-allergens: unique collect [foreach [allergen ingredients] table [keep ingredients]]
r1: length? remove-each ingredient collect [foreach [ingredients allergens] foods [keep ingredients]] [find with-allergens ingredient]
print [{Part 1:} r1]

; --- Part 2 ---
table: sort/skip collect [
  until [
    foreach [allergen ingredients] table [
      if 1 = length? ingredients [
        keep reduce [allergen ingredient: ingredients/1]
        forskip table 2 [remove find table/2 ingredient]
        remove/part find table allergen 2
        break
      ]
    ]
    empty? table
  ]
] 2
r2: remove rejoin collect [
  foreach [allergen ingredient] table [
    keep reduce [{,} ingredient]
  ]
]
print [{Part 2:} r2]
