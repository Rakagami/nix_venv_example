To recreate this bug:

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

Now we can see that the changes we now make on the python project do not get build in the nix environment. Even if we delete `src/example.py`, nix-shell environment still successfully builds and gives the sampe output.
Expected behavior is that we see the output `This is a changed Example`

```
example_repo ❯ rm src/example.py
example_repo ❯ nix-shell --pure --run "example"
[... derivation building ...]
This is an Example!
example_repo ❯
```

Even when deleting the `.venv` directory, the nix-shell has the same output

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
