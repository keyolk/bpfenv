#!/usr/bin/env bpftrace
/*
 * bashreadline    Print entered bash commands from all running shells.
 *                 For Linux, uses bpftrace and eBPF.
 *
 * This works by tracing the readline() function using a uretprobe (uprobes).
 *
 * USAGE: bashreadline.bt
 *
 * This is a bpftrace version of the bcc tool of the same name.
 *
 * Copyright 2018 Netflix, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License")
 *
 * 06-Sep-2018  Brendan Gregg   Created this.
 */

BEGIN
{
        printf("Tracing bash commands... Hit Ctrl-C to end.\n");
        printf("%-9s %-6s %s\n", "TIME", "PID", "COMMAND");
}

uretprobe:/proc/1/root/bin/bash:readline
{
        time("%H:%M:%S  ");
        printf("%-6d %s\n", pid, str(retval));
}

