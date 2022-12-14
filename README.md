To recreate this bug:

1. Clone example repository and run these commands

```
❯ git clone [this repo] example_repo && cd example_repo
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

```
example_repo ❯ rm src/example.py
example_repo ❯ nix-shell --pure --run "example"
[... derivation building ...]
This is an Example!
example_repo ❯
```
