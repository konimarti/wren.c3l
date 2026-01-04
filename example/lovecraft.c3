module lovecraft;
import wren, std::io;

fn void on_complete_fn(WrenVM vm, ZString name, WrenLoadModuleResult result)
{
	io::printfn("On complete callback: %s", name);
}

fn WrenLoadModuleResult load_fn(WrenVM vm, ZString name)
{
	io::printfn("Loading module: %s", name);

	WrenLoadModuleResult result;
	if (name == "cthulu")
	{
		result.source = cthulu;
		result.onComplete = (void*)&on_complete_fn;
	}
	return result;
}

fn void main()
{
	WrenConfiguration config;
	config.init_with_stdio();
	config.loadModuleFn = &load_fn;

	WrenVM vm = wren::create_vm(&config);
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

