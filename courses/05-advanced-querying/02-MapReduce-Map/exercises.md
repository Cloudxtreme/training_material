# MapReduce - Map

1. Add a "text/plain" object to Riak with the body "bar"

2. Extract the body of the object using MapReduce (`fun(Obj, _, _) -> [riak_object:get_value(Obj)] end.`)

3. Add an "arg" to the phase and extract its value (`fun(_, _, Arg) -> [Arg] end.`)

4. Add keydata to the inputs and extract its value (`fun(_, KD, _) -> [KD] end.`)

5. Add several more "text/plain" objects with multi-word bodies

Write a MapReduce job to...

6. count the number of times a word appears in all docs

7. count the number of times a word appears in all docs using "arg"

8. count the number of times a word appears a set of docs (explicit inputs)

9. count the number of times a word appears in a set of docs using keydata
