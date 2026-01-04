module wren;

import std::io;

<*
 init will set the default values for WrenConfiguration.
*>
fn void WrenConfiguration.init(&self) => wren::init_configuration(self);

<*
 init_with_stdio will init WrenConfiguration with default values and set writeFn and errorFn with
 stdio functions.
*>
fn void WrenConfiguration.init_with_stdio(&self)
{
	wren::init_configuration(self);
	self.writeFn = &stdio_write_fn;
	self.errorFn = &stdio_error_fn;
}

fn void stdio_write_fn(WrenVM vm, ZString text)
{
	io::print(text);
}

fn void stdio_error_fn(WrenVM vm, WrenErrorType type, ZString name, CInt line, ZString message)
{
	io::eprintfn("%s (module %s on line %d): %s", type, name, line, message);
}

