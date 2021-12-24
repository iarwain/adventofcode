REBOL [
  Title: {Day 19}
  Date: 19-12-2021
]

; Programmatically creating rotations and *heavy* optimizations would be nice, but I really don't have the motivation at the moment.

data: read %data/19.txt

area: context [
  map: size?: none
  use [scanners scanner x y z rotations match beacons] [
    scanners: collect [
      scanner: none
      parse/all data [
        some
        [ {---} thru newline (all [scanner keep/only scanner] scanner: copy [])
        | newline
        | copy x to {,} skip copy y to {,} skip copy z [to newline | to end] (append/only scanner reduce [load x load y load z]) skip
        ]
      ]
      keep/only scanner
    ]
    rotations: [
      [p/1     p/2 p/3] [p/1     (- p/3) p/2] [p/1     (- p/2) (- p/3)] [p/1     p/3 (- p/2)]
      [p/2     p/3 p/1] [p/2     (- p/1) p/3] [p/2     (- p/3) (- p/1)] [p/2     p/1 (- p/3)]
      [p/3     p/1 p/2] [p/3     (- p/2) p/1] [p/3     (- p/1) (- p/2)] [p/3     p/2 (- p/1)]
      [(- p/1) p/3 p/2] [(- p/1) (- p/2) p/3] [(- p/1) (- p/3) (- p/2)] [(- p/1) p/2 (- p/3)]
      [(- p/2) p/1 p/3] [(- p/2) (- p/3) p/1] [(- p/2) (- p/1) (- p/3)] [(- p/2) p/3 (- p/1)]
      [(- p/3) p/2 p/1] [(- p/3) (- p/1) p/2] [(- p/3) (- p/2) (- p/1)] [(- p/3) p/1 (- p/2)]
    ]
    match: funct [scanner] [
      foreach rotation rotations [
        foreach a rotated: map-each p scanner [reduce bind rotation 'p] [
          foreach b map [
            offset: reduce [b/1 - a/1 b/2 - a/2 b/3 - a/3]
            if 12 <= length? t: intersect map transformed: map-each point rotated [reduce [point/1 + offset/1 point/2 + offset/2 point/3 + offset/3]] [
              print [{Found beacon #} 1 + length? beacons {:} mold offset]
              append/only beacons offset
              set 'map unique append map transformed
              return
            ]
          ]
        ]
      ]
      none
    ]
    map: take scanners beacons: [[0 0 0]]
    until [
      any [
        match scanner: take scanners
        append/only scanners scanner
      ]
      empty? scanners
    ]
    size?: funct [] [
      result: 0
      foreach a beacons [
        foreach b beacons [
          result: max result (abs b/1 - a/1) + (abs b/2 - a/2) + (abs b/3 - a/3)
        ]
      ]
      result
    ]
  ]
]

; --- Part 1 ---
r1: length? area/map
print [{Part 1:} r1]

; --- Part 2 ---
r2: area/size?
print [{Part 2:} r2]
