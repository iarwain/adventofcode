REBOL [
  Title: {Day 22}
  Date: 22-12-2023
]

data: read/lines %data/22.txt

island: context [
  count: use [bricks above below space settle] [
    bricks: sort/compare map-each entry data [
      reduce [load take/part entry: split entry charset {,~} 3 load entry]
    ] func [a b] [a/1/3 < b/1/3]
    above: copy/deep below: array/initial length? bricks [] space: map []
    do settle: funct [] [
      forall bricks [
        id: index? bricks z: bricks/1/1/3 under: copy []
        until [
          -- z
          for x bricks/1/1/1 bricks/1/2/1 1 [
            for y bricks/1/1/2 bricks/1/2/2 1 [
              all [brick: space/(reduce [x y z]) append under brick]
            ]
          ]
          any [
            z = 0
            not empty? under
          ]
        ]
        ++ z
        bricks/1/2/3: bricks/1/2/3 + (z - bricks/1/1/3)
        bricks/1/1/3: z
        for x bricks/1/1/1 bricks/1/2/1 1 [
          for y bricks/1/1/2 bricks/1/2/2 1 [
            for z bricks/1/1/3 bricks/1/2/3 1 [
              pos: reduce [x y z]
              space/:pos: id
            ]
          ]
        ]
        below/:id: unique under
        foreach brick under [append above/:brick id]
      ]
      set 'above map-each bricks above [unique bricks]
    ]
    fall?: funct [brick] [
      fallen: copy [] queue: reduce [brick]
      until [
        id: take queue
        append fallen id
        foreach brick above/:id [
          fall: true
          foreach other below/:brick [
            unless find fallen other [fall: false break]
          ]
          all [fall append queue brick]
        ]
        empty? queue
      ]
      (length? fallen) - 1
    ]
    count: funct [/chain] [
      res: 0
      either chain [
        repeat i length? bricks [res: res + fall? i]
      ] [
        repeat i length? bricks [all [0 = fall? i ++ res]]
      ]
      res
    ]
  ]
]

; --- Part 1 ---
r1: island/count
print [{Part 1:} r1]

; --- Part 2 ---
r2: island/count/chain
print [{Part 2:} r2]
