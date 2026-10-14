# glfw-evdev.zig

Quick and dirty port of FreeBSD's evdev-proto to Linux Kernel 7.2 (latest mainline release) with Epoll-Shim support for OpenBSD targets

## Why make this ?

The full intention of this was to get tiawl's glfw.zig port to successfully target the BSDs for a project I'm working on.

## How to use it

1. Run this in the root directory of any project that depends on this port or glfw.zig:

  `zig fetch --save git+https://github.com/thearchivalone/glfw-evdev.zig.git`

2. Add these to `build.zig`:

  ```
// Add to top
const std = @import("std");
const builtin = @import("builtin"); 
```

```
// Add this before glfw_zig dependency calls
const evdev = b.dependency("evdev_zig", .{});

// Add this before linking the glfw library
if (builtin.target.os.tag == .freebsd) {
  // Add your loading and linking code here; make sure run evdev.artifact("evdev") at the start
}
```


```
// Can also use this if targeting multiple BSDs
sw: switch(builtin.target.os.tag) {
  .freebsd =>
    continue sw: .netbsd,
  .netbsd => {
    // Add loading and linking code here or add another continue if you want to support other targets
  },
  else => {} // Required if you don't want to manually support all targets at once
}

```
## Dependencies

The [Zig][3] part of this package requires the latest (0.17.0) or the master (0.18.0-dev) [Zig][3] release.

For other dependencies see [the build.zig.zon](https://github.com/tiawl/glfw.zig/blob/stable/build.zig.zon)

## `zig build` options

These additional options have mainly been implemented for maintainability tasks but they maybe could be useful for edge usecases:
```
  -Dfetch   Update build.zig.zon then stop execution
  -Dupdate  Update binding
```

## License

* Patched Linux Headers - GPL 2.0 (see LICENSE)
* Epoll-Shim Headers - MIT (see LICENSE.epoll-shim)
