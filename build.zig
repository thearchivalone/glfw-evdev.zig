const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const evdev_lib = b.addLibrary(.{
        .name = "evdev",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
        .linkage = .static,
    });
    evdev_lib.root_module.addIncludePath(b.path("include"));
    evdev_lib.root_module.addCSourceFile(.{ .file = b.path("src/evdev.c") });
    evdev_lib.installHeader(b.path("include/linux/input.h"), "linux/input.h");
    evdev_lib.installHeader(b.path("include/linux/input-event-codes.h"), "linux/input-event-codes.h");
    b.installArtifact(evdev_lib);
}
