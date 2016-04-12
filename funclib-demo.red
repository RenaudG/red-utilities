Red [
    Purpose: "Illustrate the use of some funclib.red utilities."
]

; Simple randon generator
rand100: does [random 100]


; "generator" as a function
it1: has [n] [
    either (n: random 100) > 90 [ none ][ n ]
]

print "forgen it1"
forgen x :it1 [ print x ]


; counter "generator" as an object.
it2: context [
    acc: 0
    init: does [acc: 0]
    next: does [ either (acc: acc + 1) > 9 [ none ][ acc ] ]
]

print "forgen it2"
forgen x it2 [ print x ]


; Fibonacci "generator" as an object.
fibo: context [
    a: 0
    b: 1
    init: does [a: 0 b: 1]
    next: has [c] [
        c: a
        a: b
        b: a + c
        c
    ]
]

print "forgen fibo"
forgen x fibo [
    print x
    if x > 30 [break]
]

print "give me 10 fibo"
print mold giveme 10 fibo

print "give me 10 more fibo"
print mold giveme/more 10 fibo

print "give me 10 more fibo (operator)"
print mold 10 more fibo

print "Testing a first pipe:"
pipe 10 [
    |> probe
    |> multiply 2
    |> probe
    |> subtract 16
    |> probe
    |> multiply 3
    |> probe
    |> either > 10 [ "machin" ][ "bidule" ]
]


print "creating a function as with PIPER"
pp: piper [
    |> probe
    |> multiply 2
    |> probe
    <| subtract 16
    |> probe
    |> multiply 3
    |> probe
    |> either > 10 [ "truc" ][ "chose" ]
]
print [ "pp  5 = " pp 5 "^/------^/"]
print [ "pp 10 = " pp 10 "^/------^/"]
