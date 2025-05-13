To view the data returned by `gnet_stats_copy_app()` — which includes the custom stats from your `dualpi2` queue discipline — you need to use the Linux `tc` (Traffic Control) tool with a command like:

```bash
tc -s qdisc show dev <your_interface>
```

### Steps:

#### 1. **Attach the `dualpi2` qdisc to an interface** (if you haven’t already):

```bash
tc qdisc add dev ens33 root dualpi2
```

> Replace `ens33` with your actual network interface.

#### 2. **View statistics:**

```bash
tc -s qdisc show dev ens33
```

* The `-s` (or `--stats`) flag tells `tc` to display statistics, which includes standard and custom stats (those you return via `gnet_stats_copy_app`).
* If `tc` supports your custom qdisc (compiled into `tc` or with proper plugins), it will display fields like `prob`, `delay_c`, `delay_l`, `ecn_mark`, etc.

---

### If your stats don’t appear:

#### You may need:

* A **`tc` extension** that understands `dualpi2` (via `tc_dualpi2.c` in the `iproute2` source tree).
* To recompile **`iproute2`** with your qdisc support.

#### Example of what to check in iproute2:

* A file like: `tc/q_dualpi2.c` implementing your stats formatting.
* That file should parse `tc_dualpi2_xstats` and display the fields.

---

### Debugging tip:

To confirm that your kernel is returning the custom stats properly, you can use `tc -s -d` for a more detailed dump or capture the netlink response using `strace` or `tcpdump` on `NETLINK_ROUTE`.

---

Would you like guidance on modifying or adding a `tc` extension to display these custom fields?
