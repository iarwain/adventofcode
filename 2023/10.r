REBOL [
  Title: {Day 10}
  Date: 10-12-2023
]

data: read/lines %data/10.txt

field: context [
  tiles: copy/deep data
  farthest?: does [divide length? pipes 2]
  area?: does [length? inner]
  pipes: do funct [] [
    pipe-table: reduce [
      #"-"  map [1x0 1x0 -1x0 -1x0]
      #"|"  map [0x1 0x1 0x-1 0x-1]
      #"L"  map [-1x0 0x-1 0x1 1x0]
      #"J"  map [1x0 0x-1 0x1 -1x0]
      #"F"  map [-1x0 0x1 0x-1 1x0]
      #"7"  map [1x0 0x1 0x-1 -1x0]
    ]
    next-dir?: funct [dir pos] [
      select select pipe-table tiles/(pos/y)/(pos/x) dir
    ]
    collect [
      forall tiles [
        if index: find tiles/1 #"S" [
          keep start: as-pair index? index index? tiles
        ]
      ]
      foreach test-dir [1x0 -1x0 0x1 0x-1] [
        if dir: next-dir? first-dir: test-dir pos: start + test-dir [
          keep pos
          break
        ]
      ]
      until [
        not all [
          dir: next-dir? dir pos: pos + dir
          keep pos
          last-dir: dir
        ]
      ]
      foreach [pipe dirs] pipe-table [
        all [
          dirs/:last-dir = first-dir
          tiles/(start/y)/(start/x): pipe ; Replacing S by its actual
          break
        ]
      ]
    ]
  ]
  inner: do funct [] [
    collect [
      width: length? tiles/1 height: length? tiles
      for y 1 height 1 [
        inside?: false
        for x 1 width 1 [
          either find pipes as-pair x y [
            switch tile: tiles/:y/:x [
              #"|"      [inside?: not inside?]
              #"L" #"F" [
                until [
                  ++ x
                  find {7J} pipe: tiles/:y/:x
                ]
                if any [
                  all [tile = #"L" pipe = #"7"]
                  all [tile = #"F" pipe = #"J"]
                ] [inside?: not inside?]
              ]
            ]
          ] [
            all [inside? keep as-pair x y]
          ]
        ]
      ]
    ]
  ]
  debug: does [
    for y 1 length? tiles 1 [
      for x 1 length? tiles/1 1 [
        prin case [
          find inner as-pair x y  [{I}]
          find pipes as-pair x y  [tiles/:y/:x]
          true                    [{O}]
        ]
      ]
      prin newline
    ]
  ]
]

; --- Part 1 ---
r1: field/farthest?
print [{Part 1:} r1]

; --- Part 2 ---
r2: field/area?
print [{Part 2:} r2]
