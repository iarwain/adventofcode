REBOL [
  Title: {Day 24}
  Date: 24-12-2017
]

data: load replace/all read %data/24.txt charset [{/^/}] { }

; --- Part 1 ---
bridge: context [
  components: collect [
    foreach [in out] data [keep/only reduce [in out false]]
  ]
  chain-weight?: has [weight] [
    weight: 0 foreach component components [all [component/3 weight: weight + component/1 + component/2]] weight
  ]
  max-weight?: funct [/start port [integer!]] [
    weight: 0 unless port [port: 0]
    foreach component components [
      if all [
        not component/3
        find component port
      ] [
        component/3: true
        weight: max weight max-weight?/start pick component component/1 != port
        component/3: false
      ]
    ]
    either weight = 0 [chain-weight?] [weight]
  ]
]

r1: bridge/max-weight?
print [{Part 1:} r1]

; --- Part 2 ---
bridge: make bridge [
  chain-length?: has [length] [
    length: 0 foreach component components [all [component/3 length: length + 1]] length
  ]
  max-length?: funct [/start port [integer!] /with info [object!]] [
    length: 0 unless port [port: 0 info: context [max-length: max-weight: 0]]
    foreach component components [
      if all [
        not component/3
        find component port
      ] [
        component/3: true
        length: max length max-length?/start/with pick component component/1 != port info
        component/3: false
      ]
    ]
    if length = 0 [
      if info/max-length <= length: chain-length? [
        info/max-weight: either info/max-length = length [max info/max-weight chain-weight?] [chain-weight?]
        info/max-length: length
      ]
    ]
    pick reduce [length reduce [info/max-length info/max-weight]] to-logic with
  ]
]

r2: bridge/max-length?
print [{Part 2:} r2/2]
