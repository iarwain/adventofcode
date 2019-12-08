REBOL [
  Title: {Day 8}
  Date: 08-12-2019
]

data: read %data/8.txt

; --- Part 1 ---
bios: context [
  size: 25x6 layers: remove reverse collect [
    until [empty? keep take/part data (size/x * size/y)]
  ]
  verify: has [counter value] [
    counter: first minimum-of map-each layer layers [
      counter: copy [0 0 0]
      forall layer [
        counter/(value: layer/1 - #"0" + 1): counter/:value + 1
      ]
      counter
    ]
    counter/2 * counter/3
  ]
  show: has [password window] [
    password: make image! size
    foreach layer layers [
       forall layer [
        switch layer/1 [
          #"0" [password/(index? layer): 0.0.0.0]
          #"1" [password/(index? layer): 255.0.0.0]
        ]
      ]
    ]
    save/png %password.png to-image window: layout [image (10 * size) password key #"^(esc)" [unview]]
    view window
  ]
]
r1: bios/verify
print [{Part 1:} r1]

; --- Part 2 ---
print [{Part 2: Result displayed in image.} ]
bios/show
