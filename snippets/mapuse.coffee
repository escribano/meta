# .map() is your friend here:
# list comprehensions are better suited to simple tasks
k = [0...3].map (i) ->
    foo:
        bar: "#{i}"
        baz: i
    qux: i*3
    
# Setting a variable returns the value it is set to. Its still a bit hacky,
# but slightly nicer than your version that explicitly returns g after setting it.
# Definitely a workaround for a coffeescript bug, though.
k = for x in [0...3]
   g =
      foo:
         bar:x
         baz:3
      qux:5