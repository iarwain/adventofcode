REBOL [
  Title: {Day 23}
  Date: 23-12-2023
]

data: read/lines %data/23.txt

island: context [
  pathfind: funct [] [
    begin: as-pair index? find data/1 #"." 1
    end: as-pair index? find last data #"." length? data
    longest: 0 queue: reduce ['push begin 0]
    history: array/initial reduce [length? data length? data/1] 0
    until [
      op: take queue pos: take queue
      either op = 'pop [
        history/(pos/y)/(pos/x): 0
      ] [
        distance: take queue
        insert queue reduce ['pop pos]
        foreach dir [1x0 -1x0 0x1 0x-1] [
          either end = new: pos + dir [
            longest: max longest distance + 1
          ] [
            try [
              terrain: data/(new/y)/(new/x)
              if all [
                terrain != #"#"
                any [dir != 1x0 terrain != #"<"]
                any [dir != -1x0 terrain != #">"]
                any [dir != 0x1 terrain != #"^^"]
                any [dir != 0x-1 terrain != #"V"]
                history/(new/y)/(new/x) = 0
              ] [
                history/(new/y)/(new/x): 1
                insert queue reduce ['push new distance + 1]
              ]
            ]
          ]
        ]
      ]
      empty? queue
    ]
    longest
  ]
]

; --- Part 1 ---
r1: island/pathfind
print [{Part 1:} r1]

; --- Part 2 ---
r2: 6522
; I realize that a proper way to solve part 2 would be to build a graph from the original maze, splitting on junctions.
; However, it's day 23, and I'm not feeling motivated enough at the moment, so I simply implemented the naive flood algorithm from above in C.
; This went through all paths in ~1m20s on my machine, and that's good enough for me. =)

;const char *data[] = ...(input, each line as a separate string)...
;unsigned int longest = 0;
;unsigned char history[141][141];
;unsigned int endx = 139, endy = 140;
;
;void roam(unsigned int x, unsigned int y, unsigned int distance)
;{
;  if((x == endx) && (y == endy))
;  {
;    if(distance > longest)
;    {
;      longest = distance;
;      printf("New path: %d\n", longest);
;    }
;  }
;  else
;  {
;    history[y][x] = 1;
;    distance++;
;
;    if((x > 0) && (history[y][x - 1] == 0))
;    {
;      if(data[y][x - 1] != '#') {roam(x - 1, y, distance);}
;    }
;    if((x < 140) && (history[y][x + 1] == 0))
;    {
;      if(data[y][x + 1] != '#') {roam(x + 1, y, distance);}
;    }
;    if((y > 0) && (history[y - 1][x] == 0))
;    {
;      if(data[y - 1][x] != '#') {roam(x, y - 1, distance);}
;    }
;    if((y < 140) && (history[y + 1][x] == 0))
;    {
;      if(data[y + 1][x] != '#') {roam(x, y + 1, distance);}
;    }
;
;    history[y][x] = 0;
;  }
;}
;
;int main(int argc, char *argv[])
;{
;  memset(history, 0, sizeof(history));
;  roam(1, 0, 0);
;
;  printf("Longest path: %d\n",longest);
;
;  return 0;
;}

print [{Part 2:} r2]
