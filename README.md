# colons.sh
Object oriented programming in bash. You heard it right; OOP for Bash!

# Usage
```bash
# @file my-app.sh

source /path/to/colons.sh

new Student as student

$student.on_board

$student.send_email "Welcome abroad!"

echo Boarding for $($student.get_name) is complete.
```

```bash
#!/usr/bin/env bash

# @file Student.class.sh

class Student extends User && {

  function on_board {
    read -p "What is your name? " input
    $this.__set name $input

    read -p "What is your email? " input
    $this.__set email $input
  }

  # Here we override User::send_email
  function send_email {
    local subject=$1
    EXTERNAL_IP=1 mail -s $subject $($this.__get email)
  }
}
```

```bash
#!/usr/bin/env bash

# @file User.class.sh

class User && {

  declare -i uid=0

  function __construct {
    $this.__set uid $((uid+=1))
  }

  function send_email {
    local subject=$1
    mail -s $subject $($this.__get email)
  }

  function get_name {
    printf '%s <%s>' $($this.__get name) $($this.__get email)
  }
}
```

This is how you can code in `bash` now!

# Example
Check out `./example` for a working example:
```
$ cd ./example
$ ./app.sh
```
# Objects
## Instantiation
```bash
#!/usr/bin/env bash

new Book as notebook
# Creats object $notebook an instance of Book class.
```
## Method invokation
```bash
#!/usr/bin/env bash

$notebook.annotate $notes
# Invokes method 'annotate' on $notebook with sending $notes as the first parameter
```
## Setting and Getting properties
```bash
#!/usr/bin/env bash

$notebook.__set title 'Scraps'
# Sets 'Scraps' as the value for the property 'title' for the object $notebook

echo $($notebook.__get title)
# Prints the value of the 'title' property on the object $notebook
```

# Classes
## Class definition
Every class needs to be defined in a file called `[CLASS].class.sh`
```bash
#!/usr/bin/env bash

# @file GeneralClass.class.sh

class GeneralClass && {
  ...
}
```
## Inheritance
```bash
#!/usr/bin/env bash

# @file MyClass.class.sh

class MyClass extends GeneralClass && {

  function process() {
    local name=$1
    # ...
  }
}
```
