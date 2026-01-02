module lovecraft;
import std::io, wren;

fn void write_fn(WrenVM* vm, ZString text) => io::print(text);
fn void error_fn(WrenVM* vm, WrenErrorType type, ZString name, CInt line, ZString msg)
	=> io::eprintfn("Error (%s, line %d): %s", name, line, msg);

fn WrenLoadModuleResult load_fn(WrenVM* vm, ZString name)
{
	WrenLoadModuleResult result;
	if (name == "cthulu") result.source = cthulu;
	return result;
}

fn void main()
{
	WrenConfiguration config = {
		.writeFn = &write_fn,
		.errorFn = &error_fn,
		.loadModuleFn = &load_fn,
	};

	WrenVM* vm = wren::create_vm(&config);
	defer wren::destroy_vm(vm);

	wren::interpret(vm, "lovecraft", lovecraft);
}

ZString lovecraft = `
import "cthulu" for Cthulu

class Lovecraft {
  construct new() {}
  say() { Cthulu.new().message }
}

System.print(Lovecraft.new().say())
`;

ZString cthulu = `
class Cthulu {
  construct new() {}
  message { "Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn" }
}
`;

