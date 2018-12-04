REBOL [
  Title: {Day 4}
  Date: 04-12-2018
]

data: sort read/lines %data/4.txt

; --- Part 1 ---
record: context [
  guards: strategy1: strategy2: none
  use [history ids guard most-asleep strategy] [
    history: copy []
    ids: unique collect [
      foreach log data [
        parse log [
          copy time thru {]} (date: first time: load time date/time: time/2)
          [ {guard #} copy id integer!
          | {falls asleep} (start: date)
          | {wakes up} (
                      keep id
                      for time start (date - 0:01) 0:01 [
                        repend history [id time/time]
                      ]
                    )
          ]
        ]
      ]
    ]
    guards: collect [
      forall ids [
        keep ids/1 keep context [
          id: load ids/1
          duration: 0:00
          history: copy []
          most-asleep: none
        ]
      ]
    ]
    foreach [id time] history [
      guard: guards/:id
      guard/duration: guard/duration + 0:01
      either find guard/history time [
        guard/history/:time: guard/history/:time + 1
      ] [
        repend guard/history [time 1]
      ]
    ]
    foreach guard remove-each entry guards [string? entry] [
      most-asleep: back maximum-of/skip next guard/history 2
      guard/most-asleep: context [
        time: most-asleep/1/minute
        count: most-asleep/2
      ]
    ]
    strategy: func [method] [
      guard: first sort/compare guards func [a b] method
      guard/id * guard/most-asleep/time
    ]
    strategy1: does [
      strategy [a/duration > b/duration]
    ]
    strategy2: does [
      strategy [a/most-asleep/count > b/most-asleep/count]
    ]
  ]
]
r1: record/strategy1
print [{Part 1:} r1]

; --- Part 2 ---
r2: record/strategy2
print [{Part 2:} r2]
