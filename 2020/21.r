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
dangerous: copy [] foreach [ingredients allergens] foods [
  foreach allergen allergens [
    either find dangerous allergen [
      dangerous/:allergen: intersect dangerous/:allergen ingredients
    ] [
      append dangerous reduce [allergen ingredients]
    ]
  ]
]
unsafe: unique collect [foreach [allergen ingredients] dangerous [keep ingredients]]
r1: length? remove-each ingredient collect [foreach [ingredients allergens] foods [keep ingredients]] [find unsafe ingredient]
print [{Part 1:} r1]

; --- Part 2 ---
dangerous: sort/skip collect [
  until [
    foreach [allergen ingredients] dangerous [
      if 1 = length? ingredients [
        keep reduce [allergen ingredient: ingredients/1]
        forskip dangerous 2 [remove find dangerous/2 ingredient]
        remove/part find dangerous allergen 2
        break
      ]
    ]
    empty? dangerous
  ]
] 2
r2: remove rejoin collect [
  foreach [allergen ingredient] dangerous [
    keep reduce [{,} ingredient]
  ]
]
print [{Part 2:} r2]
