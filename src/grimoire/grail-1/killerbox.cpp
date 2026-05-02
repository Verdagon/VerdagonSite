#include <memory>
#include <variant>
#include <iostream>

struct Engine {
    int fuel;

    Engine(int fuel_) : fuel(fuel_) {}
};

struct Spaceship {
    std::unique_ptr<Engine> engine;

    Spaceship(std::unique_ptr<Engine> engine_) :
        engine(std::move(engine_)) {}

    void print() {
        std::cout << "Spaceship.engine.fuel: " << engine->fuel << std::endl; // Segfault at address 0x1!
    }
};

void maintenance(std::shared_ptr<Spaceship> ship) {
    // Circuitous shapeshift: points ship->engine at a different Engine
    ship->engine = std::make_unique<Engine>(42);
}

void foo(std::shared_ptr<Spaceship> ship) {
    int& fuelRef = ship->engine->fuel;
    maintenance(ship);  // Points ship->engine at a different Engine
    fuelRef = 73;  // Writes to invalid memory through the reference
}

int main() {
  auto ship =
      std::make_shared<Spaceship>(
          std::make_unique<Engine>(42));
  foo(ship);
  ship->print();
}

// verdagon@Evans-MBP-2 grail-1 % clang++ -fsanitize=address killerbox.cpp && ./a.out
// a.out(63076,0x1ff0f3ac0) malloc: nano zone abandoned due to inability to reserve vm space.
// =================================================================
// ==63076==ERROR: AddressSanitizer: heap-use-after-free on address 0x6020000000d0 at pc 0x000100f7cd34 bp 0x00016ee86f70 sp 0x00016ee86f68
// WRITE of size 4 at 0x6020000000d0 thread T0
//     #0 0x000100f7cd30 in foo(std::__1::shared_ptr<Spaceship>)+0x18c (a.out:arm64+0x100004d30)
//     #1 0x000100f7d0c0 in main+0x1b4 (a.out:arm64+0x1000050c0)
//     #2 0x00019705e0dc  (<unknown module>)
//     #3 0xa54e7ffffffffffc  (<unknown module>)
// 
// 0x6020000000d0 is located 0 bytes inside of 4-byte region [0x6020000000d0,0x6020000000d4)
// freed by thread T0 here:
//     #0 0x0001017b9330 in _ZdlPv+0x68 (libclang_rt.asan_osx_dynamic.dylib:arm64+0x4d330)
//     #1 0x000100f7f33c in std::__1::default_delete<Engine>::operator()[abi:ue170006](Engine*) const+0x2c (a.out:arm64+0x10000733c)
//     #2 0x000100f7f2b4 in std::__1::unique_ptr<Engine, std::__1::default_delete<Engine>>::reset[abi:ue170006](Engine*)+0xc0 (a.out:arm64+0x1000072b4)
//     #3 0x000100f7cb54 in std::__1::unique_ptr<Engine, std::__1::default_delete<Engine>>::operator=[abi:ue170006](std::__1::unique_ptr<Engine, std::__1::default_delete<Engine>>&&)+0x2c (a.out:arm64+0x100004b54)
//     #4 0x000100f7c940 in maintenance(std::__1::shared_ptr<Spaceship>)+0x150 (a.out:arm64+0x100004940)
//     #5 0x000100f7ccd8 in foo(std::__1::shared_ptr<Spaceship>)+0x134 (a.out:arm64+0x100004cd8)
//     #6 0x000100f7d0c0 in main+0x1b4 (a.out:arm64+0x1000050c0)
//     #7 0x00019705e0dc  (<unknown module>)
//     #8 0xa54e7ffffffffffc  (<unknown module>)
// 
// previously allocated by thread T0 here:
//     #0 0x0001017b8f38 in _Znwm+0x68 (libclang_rt.asan_osx_dynamic.dylib:arm64+0x4cf38)
//     #1 0x000100f7ca24 in std::__1::__unique_if<Engine>::__unique_single std::__1::make_unique[abi:ue170006]<Engine, int>(int&&)+0x2c (a.out:arm64+0x100004a24)
//     #2 0x000100f7d07c in main+0x170 (a.out:arm64+0x10000507c)
//     #3 0x00019705e0dc  (<unknown module>)
//     #4 0xa54e7ffffffffffc  (<unknown module>)
// 
// SUMMARY: AddressSanitizer: heap-use-after-free (a.out:arm64+0x100004d30) in foo(std::__1::shared_ptr<Spaceship>)+0x18c
// Shadow bytes around the buggy address:
//   0x601ffffffe00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
//   0x601ffffffe80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
//   0x601fffffff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
//   0x601fffffff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
//   0x602000000000: fa fa fd fd fa fa fd fd fa fa 00 00 fa fa 00 fa
// =>0x602000000080: fa fa 00 04 fa fa 00 00 fa fa[fd]fa fa fa 04 fa
//   0x602000000100: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x602000000180: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x602000000200: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x602000000280: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x602000000300: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
// Shadow byte legend (one shadow byte represents 8 application bytes):
//   Addressable:           00
//   Partially addressable: 01 02 03 04 05 06 07
//   Heap left redzone:       fa
//   Freed heap region:       fd
//   Stack left redzone:      f1
//   Stack mid redzone:       f2
//   Stack right redzone:     f3
//   Stack after return:      f5
//   Stack use after scope:   f8
//   Global redzone:          f9
//   Global init order:       f6
//   Poisoned by user:        f7
//   Container overflow:      fc
//   Array cookie:            ac
//   Intra object redzone:    bb
//   ASan internal:           fe
//   Left alloca redzone:     ca
//   Right alloca redzone:    cb
// ==63076==ABORTING
// zsh: abort      ./a.out
// verdagon@Evans-MBP-2 grail-1 %