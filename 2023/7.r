REBOL [
  Title: {Day 7}
  Date: 07-12-2023
]

data: read/lines %data/7.txt

camel: context [
  tricks: map-each line data [
    hist: copy [] line: split line whitespace cards: line/1 value: load line/2
    foreach card cards [
      either not index: find hist card [
        repend hist [card 1]
      ] [
        index/2: index/2 + 1
      ]
    ]
    context [hand: cards histogram: sort/skip/compare/reverse hist 2 2 bid: value]
  ]
  winnings?: funct [/joker] [
    rank: pick [{J23456789TQKA} {23456789TJQKA}] to-logic joker
    score?: funct [hist] [
      if all [joker value: select hist #"J" value != 5] [
        value: take remove find hist: copy hist #"J"
        hist/2: hist/2 + value
      ]
      case [
        find hist 5                               [return 7]
        find hist 4                               [return 6]
        all [find hist 3 find hist 2]             [return 5]
        find hist 3                               [return 4]
        all [hist: find hist 2 find next hist 2]  [return 3]
        find hist 2                               [return 2]
      ]
      return 1
    ]
    sort/compare/reverse tricks funct [a b] [
      score-a: score? a/histogram score-b: score? b/histogram
      either score-a = score-b [
        hand: a/hand
        forall hand [
          if hand/1 != b/hand/(index? hand) [
            return (index? find rank hand/1) > (index? find rank b/hand/(index? hand))
          ]
        ]
      ] [
        return score-a > score-b
      ]
    ]
    res: 0 forall tricks [res: res + (tricks/1/bid * index? tricks)]
  ]
]

; --- Part 1 ---
r1: camel/winnings?
print [{Part 1:} r1]

; --- Part 2 ---
r2: camel/winnings?/joker
print [{Part 2:} r2]
