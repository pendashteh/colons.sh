# colons.sh
Object oriented programming in bash. You heard it right; OOP for Bash!

# Usage
```
# @file my-app.sh

. /path/to/colons.sh

student=$(new Student)

:: student.on_board

:: student.send_email "Welcome abroad!"

echo Boarding for $(:: student.get_name) is complete.
```

```
#!/usr/bin/env bash

# @file Student.class.sh

class Student && {

  function on_board {
    read -p "What is your name? " input
    :: this.__set name $input

    read -p "What is your email? " input
    :: this.__set email $input
  }

  function send_email {
    local subject=$1
    mail -s $subject $(:: this.__get email)
  }

  function get_name {
    printf '%s <%s>' $(:: this.__get name) $(:: this.__get email)
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

# Class definitions
Every class needs to be defined in a file called `[CLASS].class.sh`

```
#!/usr/bin/env bash

# @file MyClass.class.sh

class MyClass extends GeneralClass && {

  function process() {
    local name=$1
    # ...
  }
}
```
