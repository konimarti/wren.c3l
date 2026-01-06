// Calculate Pi with Monte Carlo
module mc;
import wren, std::io;

fn void main()
{
	WrenConfiguration config;
	config.init();

	config.bindForeignMethodFn = fn WrenForeignMethodFn(WrenVM vm, ZString mod,
		ZString class_name, bool is_static, ZString signature)
		{
			if (mod != "mc" && class_name != "PiPrinter") return null;
			return fn void(WrenVM vm) {
				double pi = wren::get_slot_double(vm, 1);
				io::printfn("invoke foreign method: %g", pi);
			};
		};

	WrenVM vm = wren::create_vm(&config);
	defer wren::destroy_vm(vm);

	wren::interpret(vm, "mc", mc);

	double pi;
	wren::ensure_slots(vm, 1);
	wren::get_variable(vm, "mc", "pi", 0);
	pi = wren::get_slot_double(vm, 0);
	io::printfn("pi variable from wren: %g", pi);
}

ZString mc = `
import "random" for Random
var rand = Random.new()

var a = 0
var n = 0
var x = 0.0
var y = 0.0

var i = 100000
while ((i = i - 1) > 0) {

	x = rand.float(1.0)
	y = rand.float(1.0)
	if (x*x + y*y <= 1.0) a = a + 1
	n = n + 1
}

var pi = 4 * a / n

class PiPrinter {
	foreign static print(pi)
}
PiPrinter.print(pi)
`;
