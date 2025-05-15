const std = @import("std");
const process = @import("../utils/process.zig");
const search = @import("../utils/search-filesystem.zig");
const release_memory = @import("../configuration.zig").release_memory;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn hBuild(args: [][:0]u8) anyerror!void {

    var build_dir: [:0]const u8 = undefined;

    if (args.len > 0) {
        if (args[0][0] != '-') // should be a valid name
            build_dir = args[0];
    } else {        
        const target: [:0]const u8 = ".configure"; // TODO: read the configuration dir from (heh) configuration, or set in build script.
        const project_dir = try search.revSearch(allocator, target);
        build_dir = try std.fmt.allocPrintZ(allocator, "{s}/{s}", .{project_dir, "build"});
        if (release_memory) allocator.free(project_dir);
    }

    var build_args = std.ArrayList([:0]const u8).init(allocator);
    try build_args.append("cmake");
    try build_args.append("--build");
    try build_args.append(build_dir);


    // TODO: pass any further args from the user (e.g. -j16 for Make); this is the same as what is done in the config command
    const arglist = try build_args.toOwnedSlice();
    try process.run(arglist);

    if (release_memory) allocator.free(build_dir);
}
