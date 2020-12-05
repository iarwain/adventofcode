REBOL [
  Title: {Day 4}
  Date: 04-12-2020
]

data: read %data/4.txt

; --- Part 1 ---
passports: collect [
  use [char rule passport count] [
    char: complement charset [{ ^/}]
    rule: [
      (passport: copy [] count: 14)
      some [
        copy key [{byr} | {iyr} | {eyr} | {hgt} | {hcl} | {ecl} | {pid} | {cid} (count: 16)] {:}
        copy value some char
        [{ } | newline | end]
        (append passport reduce [to-word key value])
      ]
    ]
    parse/all data [
      some [
        rule (
          if count = length? passport [
            keep/only passport
          ]
        )
        | skip
      ]
    ]
  ]
]
r1: length? passports
print [{Part 1:} r1]

; --- Part 2 ---
use [digit hex] [
  digit: charset [#"0" - #"9"]
  hex: union digit charset [#"a" - #"f"]
  remove-each passport passports [
    not attempt [
      all [
        (load passport/byr) >= 1920
        (load passport/byr) <= 2002

        (load passport/iyr) >= 2010
        (load passport/iyr) <= 2020

        (load passport/eyr) >= 2020
        (load passport/eyr) <= 2030

        parse/all passport/hcl [{#} 6 hex]

        parse/all passport/ecl [{amb} | {blu} | {brn} | {gry} | {grn} | {hzl} | {oth}]

        parse/all passport/pid [9 digit]

        parse/all passport/hgt [
          copy value some digit (value: load value) [
            {cm} (valid: all [value >= 150 value <= 193])
          | {in} (valid: all [value >= 59 value <= 76])
          ]
        ]
        valid
      ]
    ]
  ]
]
r2: length? passports
print [{Part 2:} r2]
