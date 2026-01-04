## Wren C3 Bindings

This project provides C3 bindings for the [Wren](https://wren.io) scripting language.

The bindings are fully standalone: the Wren source code is integrated directly
into the library, so there are no external dependencies required to embed and
run Wren from C3.

### Features

* Fully self-contained (Wren source included)
* No external libraries
* Suitable for embedding scripting into C3 applications
* Minimal and lightweight integration

### Example

```c3
import wren;
fn void main()
{
    WrenConfiguration config;
    config.init_with_stdio();
    
    WrenVM vm = wren::create_vm(&config);
    defer wren::destroy_vm(vm);
    
    wren::interpret(vm, "hello", "System.print(\"Hello from wren!\")");
}
```

See more [examples](examples/)

### Installation

1. Add the library path to your project with `dependency-search-paths`.
2. Add the dependency name to `dependencies`.

Example `project.json` snippet:

```json
{
  "dependency-search-paths": [ "lib" ],
  "dependencies": [ "wren" ]
}
```

### Roadmap / ideas

* Add wrapper code to use API in a more idiomatic C3 way.
* Include the `wren-lang` source code as a submodule.

PRs are welcome.

### License

MIT License.
