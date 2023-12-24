REBOL [
  Title: {Day 24}
  Date: 24-12-2023
]

data: read/lines %data/24.txt

hail: context [
  collisions?: use [stones] [
    stones: map-each line data [
      reduce [load first stones: split replace/all line {,} {} {@} load second stones]
    ]
    funct [] [
      res: 0 repeat i length? stones [
        for j i + 1 length? stones 1 [
          h1: stones/:i h2: stones/:j
          try [
            a1: h1/2/2 / h1/2/1       b1: h1/1/2 - (a1 * h1/1/1)
            a2: h2/2/2 / h2/2/1       b2: h2/1/2 - (a2 * h2/1/1)
            x: (b2 - b1) / (a1 - a2)  y: a1 * x + b1
            all [
              x >= 200000000000000 x <= 400000000000000
              y >= 200000000000000 y <= 400000000000000
              (x - h1/1/1 / h1/2/1) >= 0 ; t1 not in the past
              (x - h2/1/1 / h2/2/1) >= 0 ; t2 not in the past
              ++ res
            ]
          ]
        ]
      ]
      res
    ]
  ]
]

; --- Part 1 ---
r1: hail/collisions?
print [{Part 1:} r1]

; --- Part 2 ---
; This part requires solving a system of equations with 6 variables. As everyone else, I've been using an existing library to do so. :(
; I've used SimPy, but other options are Mathematica, Matlab, Maple, Z3, etc.
;sympy ->
;px  369109345096355
;py  377478862726817
;pz  138505253617233
;vx  -153
;vy  -150
;vz  296
;res 885093461440405
;
;code
;x = Symbol('x')
;y = Symbol('y')
;z = Symbol('z')
;vx = Symbol('vx')
;vy = Symbol('vy')
;vz = Symbol('vz')
;
;equations = []
;t_syms = []
;for i, stone in enumerate(stones[:3]):
;  sx, sy, sz, svx, svy, svz = stone
;  t = Symbol('t' + str(i))
;
;  eqx = x + vx * t - sx - svx * t
;  eqy = y + vy * t - sy - svy * t
;  eqz = z + vz * t - sz - svz * t
;
;  equations.append(eqx)
;  equations.append(eqy)
;  equations.append(eqz)
;  t_syms.append(t)
;
;result = solve_poly_system(equations, *([x, y, z, vx, vy, vz] + t_syms))

r2: 885093461440405
print [{Part 2:} r2]
