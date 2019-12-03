# KnowledgeLib
A package to manipulation knowledge of knowledge through a particular formal logic

## How to use
```julia
using KnowledgeLib

x_and_y = kl"(x . y)"
x_or_y = kl"(x + y)"
not_x = kl"!x"

albert_know_x = kl"albert:x"

# A common knowledge is a knowledge people have, know other have, know other people know other people have, etc…
albert_and_bernard_have_common_knowledge_about_x = kl"[albert, bernard]:x"

# albert^(n+1) is a Agent that know everything albert^n know, plus some stuffs
# albert == albert^0
albert_know_x_then_know_y_then_know_z = kl"(albert:x . albert^1:y . albert^2:z)"

random_complex_stuff = kl"(([albert,bernard]:celine:(x+y)) . (albert^1:!bernard:x + !y))"

```
