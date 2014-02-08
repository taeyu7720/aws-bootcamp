name "starter_one"
description "An example Chef role"
run_list "recipe[starter_one]"
override_attributes({
  "starter_name" => "John Doe",
})
