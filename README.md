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

[Mandelbrot](examples/mandelbrot.c3)

```c3
module mandelbrot;
import std::io, wren;

fn void write_fn(WrenVM* vm, ZString text) => io::print(text);
fn void error_fn(WrenVM* vm, WrenErrorType type, ZString module_name, CInt line, ZString msg)
	=> io::eprintfn("Error (%s, line %d): %s", module_name, line, msg);

fn void main()
{
	WrenConfiguration config = { .writeFn = &write_fn, .errorFn = &error_fn };

	WrenVM* vm = wren::create_vm(&config);
	defer wren::destroy_vm(vm);

	wren::interpret(vm, "mandelbrot", mandelbrot);
}

ZString mandelbrot = `
var yMin = -0.2
var yMax = 0.2
var xMin = -1.5
var xMax = -1.1

for (yPixel in 0...24) {
  var y = (yPixel / 24) * (yMax - yMin) + yMin
  for (xPixel in 0...80) {
    var x = (xPixel / 79) * (xMax - xMin) + xMin
    var pixel = " "
    var x0 = x
    var y0 = y
    for (iter in 0...80) {
      var x1 = (x0 * x0) - (y0 * y0)
      var y1 = 2 * x0 * y0

      // Add the seed.
      x1 = x1 + x
      y1 = y1 + y

      x0 = x1
      y0 = y1

      // Stop if the point escaped.
      var d = (x0 * x0) + (y0 * y0)
      if (d > 4) {
        pixel = " .:;+=xX$&"[(iter / 8).floor]
        break
      }
    }

    System.write(pixel)
  }

  System.print()
}
`;
```

### Installation

#### Install with `c3l`

Use [c3l](https://github.com/konimarti/c3l) to fetch and wire the dependency
automatically.

From your project root (where `project.json` lives):

```bash
# Fetch a specific version tag (recommended)
c3l fetch https://github.com/konimarti/wren.c3l v0.1.0

# Or fetch the default branch
c3l fetch https://github.com/konimarti/wren.c3l
```

This updates `project.json` and stores the compressed library under your
dependency search path.

> **Tip:** To update later, run `c3l update wren`. To remove, `c3l remove wren`.

#### Install library manually

If you prefer not to use `c3l`, update your `project.json`:
1. Add the library path to your project → `dependency-search-paths`.
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
