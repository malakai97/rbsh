## Terms

* **blank** - Space or tab
* **token** - Sequence of characters considered one unit.
* **name** - Token allowed to be a variable name.
* **metacharacter** - Character that separates tokens.
  ```| & ; ( ) < > space tab```
* **control operator** - Token that performs a control function.
  ```|| & && ; ;; ( ) | |& \n```

## Reserved Words
Anything the shell understands, so for our purposes these are ruby's
reserved words.


## Simple Command
```[Variable assignments] command arguments control_operator```

## Pipelines

```command1 [ | command2 ..]```

Commands separated by "\|".  command1.stdout is sent to command2.stdin.
Each command is executed as a separate process in a subshell.

## Lists

Sequence of pipelines separated by ```; & && ||```

### Operators
* \& - Execute the preceding command in a subshell and do not wait for it.
* \; - Execute commands separated by ; sequentially.
* \&\& - Execute command2 if command1 has exit status zero or was otherwise successful.
* \|\| - Execute command2 if and only if command1 has non-zero exit statuss or
  otherwise failed.

## Compound Commands
Bash has explicit support of "compound commands."  Ruby supports these natively
and implicitly, using its own language.

## Quoting
Bash uses quotes to remove the special meaning of characters, and then discards the
quotes.  This leads bash to require an escape sequence for each time the command
sequence will be interpreted.

rbsh also allows quoting as a method of removing special meaning, but once something
is quoted as a string, it will always be a string.  More specifically, it will be made
into an instance of the String ruby class.  rbsh will handle quoting the string
when it is sent off to other programs.

### Backslash
Unquoted backslashes have no meaning in rbsh.  Backslashes within sets of single-quotes
will be interpreted literally, as backslashes.  A backslash within a set of double quotes
will escape the special meaning (if any) of the character that follows it
(including quotes).

### Single Quotes
Characters sequences within single quotes are treated literally, and the entire sequence
is considered to be a single token.

### Double Quotes
Character sequences within double quotes retain their special string meanings, but do not
retain rbsh special meanings.  The entire sequence is considered to be a single token.
Within a double-quoted string, you may interpolate code within the brackets of ```#{}```.
See ruby's string interpolation rules.

## History
History is recorded prior to any interpretation or expansion.  As such, re-executing lines
from the history will never produce surprising results.

## Variables
You may assign a variable using the form variable=value within a single command.  This variable
is lost outside of that command, even within the same pipeline.

Assigning variables of the form @variable=value will make that variable available to the
shell and all subshells.  Assignment and reference both use the @variable form.

You may also use $ instead of @, but this feature may disappear in the future.

Variables within quotes do not have special meaning, and are interpreted as their character
representation.  The exception is when using the ```#{}``` interpolation.

## Bash Expansion Equivalencies
### Brace Expansion
Not performed; use ruby code to achieve this.

### Tilde Expansion
The tilde (~) character is treated as HOME when used in paths.  Everywhere else it is treated
literally.

### Parameter Expansion
Not applicable; use ruby.

### Command Substition
There are two ways to perform command substitution.

#### Backticks
\`command\` will execute the command, then treat its output as another command, variable,
or argument, depending on its placement in the grammar.   Command may be nested an
arbitrary number of times within backticks by using the ```#{}``` interpolation style.

#### Send
Send accepts a command and an optional list of arguments.  ```send(command, arg1, arg2)```

### Arithmetic Expansion
Implicitly performed by ruby.

### Process Substitution
Not performed.

### Word Splitting
In general, rbsh just does what you meant.  Specifically, anything you define as a string
won't be mutated.

### Pathname Expansion
Outside of strings, rbsh attempts to expand paths just "do the right thing" concerning
paths and globs. It uses ruby's Pathname, Dir, and File methods.

### Pattern Matching
See ruby's Regexp class.  Note that regexes do not appear within strings.  rbsh prefers
to interpret words that begin with a forward slash as file paths.  The %r() notation
is not subject to this conflict.

### Quote Removal
Strings wrapped in quotes are stored internally without those quotes.  Escaped quotes
within those strings are never mangled.

## Redirection
The stdout, stderr, and stdin of commands may be redirected.  Redirection is always
attached to the preceding command.  Additionally, redirection operators separate
commands, and such must appear after any arguments to the command.  They do not
conflict with the redirection performed by pipelines.

A failure to open or create a file causes the redirection to fail.


### Redirecting Input
```command < file``` causes the file's contents to be read into the command as stdin.  This is
exactly the same as ```cat file | command```.

### Redirecting Output
```command 1> file``` causes the stdout of the command to be written to the file.  If the
file doesn't exist, it will be created (even if there is no output).  If it does exist,
its contents will be overwritten.  The 1 may be omitted.

### Appending Redirected Output
```command 1>> file``` is exactly as above, except the output is appended to the file
intead of overwriting it.  The 1 may be omitted.

### Redirecting Standard Error
```command 2> file``` behaves exactly as above, except only stderr will be sent to the file.
The append mode is also supported via ```command 2>> file```.

### Combining Standrd Output and Error
Simply redirect both streams.  ```command 1> file 2> file``` The ```2>&1``` syntax
supported by bash is not supported by rbsh.

### Here Strings
Uses ruby's native support.


