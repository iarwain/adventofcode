REBOL [
  Title: {Day 14}
  Date: 14-12-2019
]

data: read %data/14.txt

; --- Part 1 ---
factory: context [
  recipes: make hash! []
  use [letters chemical quantity type ingredients] [
    letters: reduce ['some charset [#"A" - #"Z"]]
    chemical: [copy quantity integer! copy type letters opt {,}]
    parse data [
      some [
        (ingredients: copy [])
        some [
          chemical (append ingredients reduce [trim type to-decimal load quantity])
        ]
        {=>}
        chemical (append recipes reduce [trim type to-decimal load quantity ingredients])
        newline
      ]
    ]
  ]
  ore?: funct [quantity [number!] material [string!] /decimal] [
    left-over: make hash! []
    ingredients?: funct [quantity material] [
      materials: next find recipes material
      unless left: select left-over material [
        append left-over reduce [material left: 0.0]
      ]
      either left >= quantity [
        left-over/:material: left - quantity
        copy []
      ] [
        quantity: quantity - left requested: first+ materials
        factor: round/ceiling (quantity / requested)
        left-over/:material: factor * requested - quantity
        collect [
          foreach [ingredient quantity] materials/1 [
            keep reduce [ingredient factor * quantity]
          ]
        ]
      ]
    ]
    materials: reduce [material to-decimal quantity] clear left-over ore: 0
    until [
      materials: collect [
        foreach [material quantity] materials [
          either material = "ORE" [
            ore: ore + quantity
          ] [
            keep ingredients? quantity material
          ]
        ]
      ]
      empty? materials
    ]
    either decimal [ore] [to-integer ore]
  ]
  fuel?: funct [ore [number!]] [
    delta: 1'024 * 1'024 guess: 0.0
    until [
      fuel: guess
      until [
        fuel: fuel + delta
        ore < ore?/decimal fuel "FUEL"
      ]
      guess: fuel - delta
      (delta: delta / 2.0) < 1.0
    ]
    to-integer guess
  ]
]

r1: factory/ore? 1 "FUEL"
print [{Part 1:} r1]

; --- Part 2 ---

r2: factory/fuel? 1'000'000'000'000
print [{Part 2:} r2]
