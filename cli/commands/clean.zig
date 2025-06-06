// Copyright (c) 2025
// Licensed under the GPLv3 — see LICENSE file for details.


const std = @import("std");
const search = @import("../utils/search-filesystem.zig");
const configuration = @import("../configuration.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();


pub fn hClean(args: [][:0]u8) anyerror!void {

    var build_dir: [:0]const u8 = undefined;

    if (args.len > 0) {
        if (args[0][0] != '-') // should be a valid name
            build_dir = args[0];
    } else {        
        const target: [:0]const u8 = configuration.configuration_dir;
        const project_dir = try search.revSearch(allocator, target);
        build_dir = try std.fmt.allocPrintZ(allocator, "{s}/{s}", .{project_dir, configuration.default_build_dir});
        if (configuration.release_memory) allocator.free(project_dir);
    }

    // Run a couple of checks to ensure you are indeed deleting a valid CMake build directory
    const cwd = std.fs.cwd();

    if (cwd.access(build_dir, .{})) |_| {
        {} // do nothing
    } else |_| {
        try std.io.getStdOut().writer().print("Failed to access directory: {s}\n", .{build_dir});
        return;
    }

    const cmake_files_path = try std.fmt.allocPrintZ(allocator, "{s}/{s}", .{build_dir, "CMakeFiles"});
    
    if (cwd.access(cmake_files_path, .{})) |_| {
        try cwd.deleteTree(build_dir); // might be a tad excessive for a clean
    } else |_| {
        try std.io.getStdOut().writer().print("Failed to locate {s} - will not proceed with clean.\n", .{cmake_files_path});
    }

    if (configuration.release_memory) allocator.free(cmake_files_path);
}


