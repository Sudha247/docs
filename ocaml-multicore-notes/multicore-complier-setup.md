# Multicore Compiler Setup

## Install opam

```
$ sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
```

For more details: https://opam.ocaml.org/doc/Install.html

## Install Multicore

```
$ opam repository add multicore https://github.com/ocamllabs/multicore-opam.git
$ opam switch create <name> --empty # Note: switch name can be anything.
$ opam switch <name>
$ opam install ocaml-variants.4.06.1+multicore
```


## Install jbuilder and dune

* Dune segfaults with multicore.
  - Two solutions
  - One: use `stedolan's` pinned repo of dune that builds with the multicore compiler.
  - Two: Build dune with the standard compiler and copy files to the multicore opam switch directory.
* jbuilder installs fine on multicore.
