## Setup explanation

This repository contains a simple python package that install the command `example` that has the output `This is an Example!`. The `shell.nix` builds a python application with this package and creates a shell derivation.

## To recreate this bug

1. Clone example repository and run these commands

```
❯ git clone git@github.com:Rakagami/nix_venv_example.git example_repo && cd example_repo
example_repo ❯ nix-shell --pure --run "example"
[... derivation building ...]
This is an Example!
example_repo ❯
```

2. Create a venv environment within the `example_repo`, 

```
example_repo ❯ python3 -m venv .venv && source .venv/bin/activate
example_repo (example_repo) ❯ pip install . && example
[... pip installing ...]
This is an Example!
example_repo (example_repo) ❯
```

3. Deactivate `example_repo` venv environment, change the example output and run nix-shell again

```
example_repo (example_repo) ❯ deactivate
example_repo ❯ sed -i "s/This is an Example/This is a changed Example/g" src/example.py
example_repo ❯ python3 -m venv .venv && source .venv/bin/activate
example_repo ❯ nix-shell --pure --run "example"
[... derivation building ...]
This is an Example!
example_repo ❯
```

Now we can see that the changes we now make on the python project do not get build in the nix environment.

Expected behavior is that we see the output `This is a changed Example`

Even deleting the `src/example.py` entirely doesn't do anything.
```
example_repo ❯ rm src/example.py
example_repo ❯ nix-shell --pure --run "example"
[... derivation building ...]
This is an Example!
example_repo ❯
```

Deleting the `.venv` directory also doesn't affect it, the nix-shell has the same output

```
example_repo ❯ rm -rf .venv
example_repo ❯ nix-shell --pure --run "example"
[... derivation building ...]
This is an Example!
example_repo ❯
```

Expected behavior happens if we clone the repo somehwere else, apply changes and do nix-shell then

```
example_repo2 ❯ sed -i "s/This is an Example/This is a changed Example/g" src/example.py
example_repo2 ❯ nix-shell --pure --run "example"
[... derivation building ...]
This is a changed Example!
```
