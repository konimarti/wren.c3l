module skynet;
import wren;

fn void main()
{
	WrenConfiguration config;
	config.init_with_stdio();

	WrenVM vm = wren::create_vm(&config);
	defer wren::destroy_vm(vm);

	wren::interpret(vm, "skynet", skynet);
}

ZString skynet = `
// A million fiber microbenchmark based on: https://github.com/atemerev/skynet.
class Skynet {
  static makeFiber(num, size, div) {
    return Fiber.new {
      if (size == 1) {
        Fiber.yield(num)
      } else {
        var fibers = []
        for (i in 0...div) {
          var subNum = num + i * (size / div)
          fibers.add(makeFiber(subNum, size / div, div))
        }

        var sum = 0
        for (task in fibers) {
          sum = sum + task.call()
        }
        Fiber.yield(sum)
      }
    }
  }
}

var start = System.clock
var result = Skynet.makeFiber(0, 1000000, 10).call()
var end = System.clock
System.print("Result: %(result) in %(end - start) s")
`;
