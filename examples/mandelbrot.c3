module mandelbrot;
import std::io, wren;

fn void write_fn(WrenVM* vm, ZString text) => io::print(text);
fn void error_fn(WrenVM* vm, WrenErrorType type, ZString module_name, CInt line, ZString msg)
	=> io::eprintfn("Error (%s, line %d): %s", module_name, line, msg);

fn void main() => run_wren();

fn void run_wren()
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
