REBOL [
  Title: {Day 20}
  Date: 20-12-2020
]

data: read %data/20.txt

; --- Part 1 ---
map: context [
  content: reassemble: roughness?: none
  use [transform tile] [
    transform: funct [image] [
      pos: 0x0 collect [
        parse/all image [
          some [
            newline (pos: as-pair 0 pos/y + 1)
          | [#"#" (keep pos) | skip] (pos: pos + 1x0)
          ]
        ]
      ]
    ]
    content: copy []
    reassemble: funct [] [
      cameras: collect [
        parse data [
          some [
            {Tile } copy id to {:} thru newline
            copy tile 10 [thru newline | to end] (keep reduce [id transform tile])
          | skip
          ]
        ]
      ]
      clear content queue: copy [] pool: extract cameras 2
      ops: collect [
        foreach flip [1x1 [-1x1 + 9x0] [-1x-1 + 9x9] [1x-1 + 0x9]] [
          foreach rotation [[pixel] [(as-pair pixel/y pixel/x)]] [
            keep/only append append copy rotation '* flip
          ]
        ]
      ]
      variants: copy [] foreach [id tile] cameras [
        append variants reduce [id collect [foreach op ops [keep/only map-each pixel tile [do bind op 'pixel]]]]
      ]
      dirs: [1x0 -1x0 0x1 0x-1]
      edge?: funct [tile dir] [
        res: 0 switch dir [
          1x0   [foreach pixel tile [if pixel/x = 9 [res: res + shift/left 1 pixel/y]]]
          -1x0  [foreach pixel tile [if pixel/x = 0 [res: res + shift/left 1 pixel/y]]]
          0x1   [foreach pixel tile [if pixel/y = 9 [res: res + shift/left 1 pixel/x]]]
          0x-1  [foreach pixel tile [if pixel/y = 0 [res: res + shift/left 1 pixel/x]]]
        ]
        res
      ]
      do add-tile: func [pos id tile] [
        append content reduce [pos id tile]
        remove find pool id
        foreach dir dirs [unless find content pos + dir [queue: unique append queue pos + dir]]
      ] 0x0 cameras/1 cameras/2
      until [
        check: take queue neighbors: collect [
          foreach dir dirs [
            if neighbor: select content check + dir [keep reduce [neighbor dir edge? content/:neighbor negate dir]]
          ]
        ]
        do does [
          foreach id pool [
            foreach variant variants/:id [
              if foreach [neighbor dir match] neighbors [
                if match = edge? variant dir [break/return true]
              ] [
                add-tile check id variant return
              ]
            ]
          ]
        ]
        empty? queue
      ]
      top-left: first minimum-of/skip content 3
      bottom-right: first maximum-of/skip content 3
      res: 1.0 foreach pos reduce [
        top-left
        as-pair bottom-right/x top-left/y
        bottom-right
        as-pair top-left/x bottom-right/y
      ] [res: res * load content/:pos]
      res
    ]
    roughness?: funct [monster] [
      sea: collect [
        foreach [pos id tile] content [
          foreach pixel tile [
            if all [
              pixel/x != 0
              pixel/x != 9
              pixel/y != 0
              pixel/y != 9
            ] [
              keep pixel + (8x8 * pos)
            ]
          ]
        ]
      ]
      monster: transform monster variants: collect [
        foreach op collect [
          foreach flip [1x1 -1x1 -1x-1 1x-1] [
            foreach rotation [[offset] [as-pair offset/y negate offset/x]] [
              keep/only append reduce [flip '*] rotation
            ]
          ]
        ] [keep/only map-each offset map-each pixel next monster [pixel - monster/1] op]
      ]
      until [
        count: 0 offsets: first+ variants
        foreach pixel sea [
          unless foreach offset offsets [
            unless find sea pixel + offset [break/return true]
          ] [count: count + 1]
        ]
        count != 0
      ]
      (length? sea) - (count * length? monster)
    ]
  ]
]
r1: map/reassemble
print [{Part 1:} r1]

; --- Part 2 ---
r2: map/roughness? {
                  #
#    ##    ##    ###
 #  #  #  #  #  #
}
print [{Part 2:} r2]
