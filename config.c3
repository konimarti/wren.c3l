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

<*
 Implements the WrenWriteFn.

 @param [&inout] vm : "Wren Virtual Machine"
 @param text : "Output text"
*>
fn void stdio_write_fn(WrenVM vm, ZString text)
{
	io::print(text);
}

<*
 Implements the WrenErrorFn.

 @param [&inout] vm : "Wren Virtual Machine"
 @param type : "Kind of error"
 @param name : "Module name where error occured"
 @param line : "Line where error occured"
 @param message : "Error message"
*>
fn void stdio_error_fn(WrenVM vm, WrenErrorType type, ZString name, CInt line, ZString message)
{
	io::eprintfn("%s (module %s on line %d): %s", type, name, line, message);
}

<*
 Implements the WrenReallocateFn for the heap allocator.
*>
fn void* reallocate(void* memory, CUInt size, void* user_data)
	=> allocator::realloc(mem, memory, size);

<*
 Implements the WrenReallocateFn for the temp allocator.
*>
fn void* treallocate(void* memory, CUInt size, void* user_data)
	=> allocator::realloc(tmem, memory, size);

