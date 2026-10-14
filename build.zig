const std = @import("std");
const build_zig_zon = @import("build.zig.zon");
const toolbox = @import("toolbox");
const VerboseBuilder = toolbox.VerboseBuilder;

fn updateFn(pkg_builder: *VerboseBuilder) !void {
    try pkg_builder.remove(&.{"evdev"});
    try pkg_builder.make(&.{"evdev"});
}

fn buildFn(pkg_builder: *VerboseBuilder) !void {
    const lib = pkg_builder.addLibrary("evdev");

    while (try pkg_builder.walk(&.{"evdev"})) |*entry| {
        if (toolbox.isCHeader(entry.basename)) pkg_builder.installHeader(lib, &.{ "evdev", entry.path }, &.{entry.path});
    }

    pkg_builder.addInclude(lib, &.{"evdev"});
    pkg_builder.installArtifact(lib);
}

pub fn build(builder: *std.Build) !void {
    var pkg_builder = try VerboseBuilder.init(builder, @tagName(build_zig_zon.name), buildFn, updateFn);

    // Use this to suppress the library from getting built if the target is not a BSD
    sw: switch (pkg_builder.getOs()) {
        .freebsd =>
            continue :sw .netbsd,
        .netbsd =>
            continue :sw .openbsd,
        .openbsd => {
            try pkg_builder.fetch(@TypeOf(build_zig_zon.dependencies), build_zig_zon.dependencies, pkg_builder.ptrCwd());
            try pkg_builder.update();
            try pkg_builder.build();
        },
        else => {}
    }
}
