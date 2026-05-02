#include <memory>
#include <variant>
#include <iostream>

struct Spaceship {
    std::variant<bool, std::string> v;

    Spaceship(std::variant<bool, std::string> v_) :
        v(std::move(v_)) {}

    void print() {
      // Print the contents of ship
      if (std::holds_alternative<std::string>(v)) {
          auto& stringRef = std::get<std::string>(v);
          std::cout << "Fuel: " << stringRef << std::endl; // Segfault at address 0x1!
      } else if (std::holds_alternative<bool>(v)) {
          bool& boolRef = std::get<bool>(v);
          std::cout << "Spaceship.v.bool: " << boolRef << std::endl; // Segfault at address 0x1!
      }
    }
};

void maintenance(std::shared_ptr<Spaceship> ship) {
    // Circuitous shapeshift: changes ship->v to hold Engine pointer
    ship->v = std::string("The most glorious ship to ever sail the stars");
}

void foo(std::shared_ptr<Spaceship> ship) {
    if (std::holds_alternative<bool>(ship->v)) {
        bool& boolRef = std::get<bool>(ship->v);
        maintenance(ship);  // Changes ship->v to hold Engine pointer
        boolRef = true;  // Writes to invalid memory through the reference
    }
}

int main() {
  auto ship =
      std::make_shared<Spaceship>(
          std::variant<bool, std::string>{true});
  foo(ship);
  ship->print();
}

// verdagon@Evans-MBP-2 grail-1 % clang++ -fsanitize=address killerunion.cpp && ./a.out
// a.out(62625,0x1ff0f3ac0) malloc: nano zone abandoned due to inability to reserve vm space.
// =================================================================
// ==62625==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x604000000401 at pc 0x0001038140f0 bp 0x00016ce62230 sp 0x00016ce619f0
// READ of size 45 at 0x604000000401 thread T0
//     #0 0x0001038140ec in memchr+0x18c (libclang_rt.asan_osx_dynamic.dylib:arm64+0x7c0ec)
//     #1 0x000197281f28 in __sfvwrite+0x26c (libsystem_c.dylib:arm64+0x4f28)
//     #2 0xed7d80019729cdc8  (<unknown module>)
//     #3 0x22298001038142a8  (<unknown module>)
//     #4 0x000102f9fad4 in std::__1::basic_streambuf<char, std::__1::char_traits<char>>::sputn[abi:ue170006](char const*, long)+0xa8 (a.out:arm64+0x100003ad4)
//     #5 0x000102f9f5b0 in std::__1::ostreambuf_iterator<char, std::__1::char_traits<char>> std::__1::__pad_and_output[abi:ue170006]<char, std::__1::char_traits<char>>(std::__1::ostreambuf_iterator<char, std::__1::char_traits<char>>, char const*, char const*, char const*, std::__1::ios_base&, char)+0x368 (a.out:arm64+0x1000035b0)
//     #6 0x000102f9ee60 in std::__1::basic_ostream<char, std::__1::char_traits<char>>& std::__1::__put_character_sequence[abi:ue170006]<char, std::__1::char_traits<char>>(std::__1::basic_ostream<char, std::__1::char_traits<char>>&, char const*, unsigned long)+0x374 (a.out:arm64+0x100002e60)
//     #7 0x000102f9e8d4 in std::__1::basic_ostream<char, std::__1::char_traits<char>>& std::__1::operator<<[abi:ue170006]<char, std::__1::char_traits<char>, std::__1::allocator<char>>(std::__1::basic_ostream<char, std::__1::char_traits<char>>&, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>> const&)+0x3c (a.out:arm64+0x1000028d4)
//     #8 0x000102f9d674 in Spaceship::print()+0x58 (a.out:arm64+0x100001674)
//     #9 0x000102f9d21c in main+0x1d4 (a.out:arm64+0x10000121c)
//     #10 0x00019705e0dc  (<unknown module>)
//     #11 0xd3247ffffffffffc  (<unknown module>)
// 
// 0x604000000401 is located 15 bytes before 48-byte region [0x604000000410,0x604000000440)
// allocated by thread T0 here:
//     #0 0x0001037e4f38 in _Znwm+0x68 (libclang_rt.asan_osx_dynamic.dylib:arm64+0x4cf38)
//     #1 0x000197317514 in std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>::__init(char const*, unsigned long)+0x4c (libc++.1.dylib:arm64+0x1b514)
//     #2 0xd96e800102fa0a1c  (<unknown module>)
//     #3 0x000102f9cc34 in std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>::basic_string[abi:ue170006]<0>(char const*)+0x20 (a.out:arm64+0x100000c34)
//     #4 0x000102f9cb48 in maintenance(std::__1::shared_ptr<Spaceship>)+0x134 (a.out:arm64+0x100000b48)
//     #5 0x000102f9ce30 in foo(std::__1::shared_ptr<Spaceship>)+0x148 (a.out:arm64+0x100000e30)
//     #6 0x000102f9d204 in main+0x1bc (a.out:arm64+0x100001204)
//     #7 0x00019705e0dc  (<unknown module>)
//     #8 0xd3247ffffffffffc  (<unknown module>)
// 
// SUMMARY: AddressSanitizer: heap-buffer-overflow (libsystem_c.dylib:arm64+0x4f28) in __sfvwrite+0x26c
// Shadow bytes around the buggy address:
//   0x604000000180: fa fa 00 00 00 00 00 05 fa fa 00 00 00 00 00 00
//   0x604000000200: fa fa 00 00 00 00 00 05 fa fa 00 00 00 00 00 00
//   0x604000000280: fa fa 00 00 00 00 00 07 fa fa 00 00 00 00 00 00
//   0x604000000300: fa fa 00 00 00 00 00 00 fa fa 00 00 00 00 00 00
//   0x604000000380: fa fa 00 00 00 00 00 05 fa fa fd fd fd fd fd fd
// =>0x604000000400:[fa]fa 00 00 00 00 00 00 fa fa fa fa fa fa fa fa
//   0x604000000480: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x604000000500: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x604000000580: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x604000000600: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
//   0x604000000680: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
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
// ==62625==ABORTING
// Fuel: zsh: abort      ./a.out
// verdagon@Evans-MBP-2 grail-1 %
