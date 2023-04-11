<p style="text-align: right"><i>- 05/09/2022 -</i></p>

# Packaging under NixOS

The following command build a local package (derivation) add keep the build folder for debugging.

```bash
nix-build --keep-failed -E '(import <nixpkgs> {}).callPackage ./default.nix {}'
```

You can also run the following to get a clean shell with all the build elements required by your derivation.

```bash
nix-shell -E '(import <nixpkgs> {}).callPackage ./default.nix {}'
```

TIPS: In this `nix-shell`, you can create a temporary dir to run packaging phases:

```bash
cd $(mktemp -d) && unpackPhase && ...
```

If a binary is showing the `No such file or directory`, some paths are broken in the binary's headers.

First the "interpreter" can be wrong, check it with `file mybinary`. To fix this, you can add the following patch in the derivation's `installPhase`:

```bash
patchelf --set-interpreter $(patchelf --print-interpreter `which cp`) $out/my/binary
```

The libraries may also be broken (see `ldd mybinary`). If so, once in the `nix-shell`, you can find the packages to add using the following oneliner

```bash
ldd /nix/store/.../bin/mybinary | grep 'not found' | sed 's/\s\([^ ]*\) .*/\1/' | xargs -n 1 find /nix/store -name | sed 's!^[^-]*-\(.*\)-[^-]*/.*!\1!' | sort -u | tee missing-libs
```

_details_

```bash
ldd /nix/store/.../bin/mybinary \         # get dependancy description of the elf file
  | grep 'not found' \                    # filter only missing dependancies
  | sed 's/\s\([^ ]*\) .*/\1/' \          # get the library name from ldd's output
  | xargs -n 1 find /nix/store -name \    # search the following library in the store
  | sed 's!^[^-]*-\(.*\)-[^-]*/.*!\1!' \  # only keep the package name from the store path
  | sort -u \                             # filter output
  | tee missing-libs                      # store the result in a file name "missing-libs"
```

Then, add the following nix variable in your derivation filled with the package names you just found:

```nix
LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ ... ];
```

And use the `makeWrapper` script to fix environment variables :

```bash
makeWrapper $out/opt/mybinary $out/bin/mybinary \
  --prefix LD_LIBRARY_PATH : ${LD_LIBRARY_PATH}:$out/opt/bloodhound/
```
