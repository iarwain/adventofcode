REBOL [
  Title: {Day 16}
  Date: 16-12-2023
]

data: read/lines %data/16.txt

beams: context [
  energy?: funct [/best] [
    shine: funct [pos dir] [
      visited: context [hashmap: map [] history: copy []]
      lights: reduce [pos dir]
      until [
        empty? lights: collect [
          foreach [pos dir] lights [
            unless find visited/hashmap key: pos * 1000 + dir [
              if attempt [value: data/(pos/y)/(pos/x)] [
                append visited/history pos
                visited/hashmap/:key: true
                case [
                  all [value = #"|" dir/y = 0]  [keep reduce [pos + 0x1 0x1] keep reduce [pos + 0x-1 0x-1]]
                  all [value = #"-" dir/x = 0]  [keep reduce [pos + -1x0 -1x0] keep reduce [pos + 1x0 1x0]]
                  value = #"/"                  [keep reduce [pos + dir: negate as-pair dir/y dir/x dir]]
                  value = #"\"                  [keep reduce [pos + dir: as-pair dir/y dir/x dir]]
                  true                          [keep reduce [pos + dir dir]]
                ]
              ]
            ]
          ]
        ]
      ]
      length? unique visited/history
    ]
    either best [
      res: 0
      for y 1 length? data 1 [
        res: maximum res shine as-pair 1 y 1x0
        res: maximum res shine as-pair length? data/1 y -1x0
      ]
      for x 1 length? data/1 1 [
        res: maximum res shine as-pair x 1 0x1
        res: maximum res shine as-pair x length? data 0x-1
      ]
      res
    ] [
      shine 1x1 1x0
    ]
  ]
]

; --- Part 1 ---
r1: beams/energy? ; ~0.180s on my computer, needs to be optimized...
print [{Part 1:} r1]

; --- Part 2 ---
r2: beams/energy?/best ; This takes ~50s on my computer...
print [{Part 2:} r2]
