REBOL [
  Title: {Day 11}
  Date: 11-12-2018
]

data: load %data/11.txt

; --- Part 1 ---
grid: context [
  fixed: adaptive: none
  use [powers power id get-power get-power-inc] [
    powers: copy [] cells: array [300 300]
    repeat y 300 [
      repeat x 300 [
        power: (id: x + 10) * y + data * id / 100
        cells/:y/:x: round/floor (power // 10) - 5
      ]
    ]
    get-power: funct [pos-x pos-y size] [
      result: 0
      for x pos-x pos-x + size - 1 1 [
        for y pos-y pos-y + size - 1 1 [
          result: result + cells/:y/:x
        ]
      ]
      result
    ]
    get-power-inc: funct [pos-x pos-y result size] [
      y: pos-y + size - 1 for x pos-x pos-x + size - 1 1 [result: result + cells/:y/:x]
      x: pos-x + size - 1 for y pos-y pos-y + size - 2 1 [result: result + cells/:y/:x]
    ]
    fixed: funct [size] [
      best-power: 0 best-pos: 0x0
      repeat y 301 - size [
        repeat x 301 - size [
          power: get-power x y size
          all [
            power > best-power
            best-power: power best-pos: as-pair x y
          ]
        ]
      ]
      repend powers [size best-power]
      rejoin [best-pos/x "," best-pos/y]
    ]
    adaptive: funct [] [
      best-pos: 0x0 best-power: any [powers/2 0] best-size: min-size: any [powers/1 1]
      y: 1 until [
        x: 1 until [
          local-best: -4 * (size: min-size) * size power: get-power x y (size - 1)
          until [
            power: get-power-inc x y power size
            all [
              power > best-power
              best-power: power
              best-pos: as-pair x y
              best-size: size
              min-size: round/ceiling square-root best-power / 4
              power > local-best
              local-best: power
            ]
            size: size + 1
            (size > (min (301 - x) (301 - y))) or (power < (local-best / 4))
          ]
          (x: x + 1) > (301 - min-size)
        ]
        (y: y + 1) > (301 - min-size)
      ]
      rejoin [best-pos/x "," best-pos/y "," best-size]
    ]
  ]
]
r1: grid/fixed 3
print [{Part 1:} r1]

; --- Part 2 ---
r2: grid/adaptive
print [{Part 2:} r2]
