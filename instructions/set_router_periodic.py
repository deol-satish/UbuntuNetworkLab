import pandas as pd

def generate_bash_script(csv_file_path):
    """
    Reads data from a CSV file and generates a bash script to apply
    tc rules iteratively.
    """
    try:
        df = pd.read_csv(csv_file_path)
    except FileNotFoundError:
        print(f"Error: The file '{csv_file_path}' was not found.")
        return
    except Exception as e:
        print(f"Error reading CSV file: {e}")
        return

    # Check for required columns
    required_columns = [
        'Sydney_BEST_Thrpt',
        'Sydney_BEST_Latency',
        'Sydney_BEST_BER_QPSK'
    ]
    missing_columns = [col for col in required_columns if col not in df.columns]
    if missing_columns:
        print(f"Error: CSV file is missing required columns: {', '.join(missing_columns)}")
        return

    script_lines = [
        "#!/bin/bash",
        "",
        "# Set basic configuration values",
        "set -x",
        "",
        "# Source the settings file",
        "if [ ! -f ./utils/settings.sh ]; then",
        "    echo \"Error: settings.sh file not found\"",
        "    exit 1",
        "fi",
        "source ./utils/settings.sh",
        "",
        "# Kill any running iperf3 instances and other tools",
        "ssh root@\"$router_ipaddr\" \"sudo killall iperf3; sudo killall tcpdump;\"",
        "ssh root@\"$client1_ipaddr\" \"sudo killall iperf3; sudo killall tcpdump; sudo killall udp_prague_sender;\"",
        "ssh root@\"$client2_ipaddr\" \"sudo killall iperf3; sudo killall tcpdump; sudo killall udp_prague_sender;\"",
        "ssh root@\"$server_ipaddr\" \"sudo killall iperf3; sudo killall tcpdump; sudo killall udp_prague_receiver;\"",
        "",
        "echo \"Initial cleanup complete.\"",
        ""
    ]

    for index, row in df.iterrows():
        try:
            # Extract values, converting to numeric where appropriate
            # Sydney Parameters
            sydney_thrpt = pd.to_numeric(row['Sydney_BEST_Thrpt'], errors='coerce')
            sydney_latency = pd.to_numeric(row['Sydney_BEST_Latency'], errors='coerce')
            sydney_ber_qpsk = pd.to_numeric(row['Sydney_BEST_BER_QPSK'], errors='coerce')

            # Handle cases where conversion might result in NaN (Not a Number)
            if pd.isna(sydney_thrpt) or pd.isna(sydney_latency) or pd.isna(sydney_ber_qpsk):
                print(f"Warning: Skipping row {index + 1} due to invalid numeric data for Sydney parameters.")
                script_lines.append(f"# Skipping datapoint {index + 1} due to invalid data: {row.to_dict()}")
                continue

            # Convert BER to percentage for packet loss
            # E.g., BER = 0.001 -> 0.1% loss
            sydney_loss_percentage = sydney_ber_qpsk * 100

            script_lines.append(f"# Applying configuration for datapoint {index + 1}")
            script_lines.append(f"echo \"Applying network conditions for datapoint {index + 1}: Sydney Thrpt: {sydney_thrpt} Mbps, Sydney Latency: {sydney_latency} ms, Sydney Loss: {sydney_loss_percentage:.4f}%\"")
            
            # Clear previous qdiscs (make it robust by ignoring errors if no qdisc exists)
            script_lines.append("ssh root@\"$router_ipaddr\" \"sudo tc qdisc del dev ens37 root 2>/dev/null || true\"")
            
            # Add new qdiscs
            # Netem for delay and loss
            script_lines.append(f"ssh root@\"$router_ipaddr\" \"sudo tc qdisc add dev ens37 root handle 1: netem delay {sydney_latency}ms loss {sydney_loss_percentage:.4f}%\"")
            # TBF for rate limiting, parented to netem. The latency for TBF is its own buffer parameter, not the netem delay.
            script_lines.append(f"ssh root@\"$router_ipaddr\" \"sudo tc qdisc add dev ens37 parent 1: handle 2: tbf rate {sydney_thrpt}mbit burst 32kbit latency 10ms\"")
            # DualPI2 for AQM, parented to TBF
            script_lines.append("ssh root@\"$router_ipaddr\" \"sudo tc qdisc add dev ens37 parent 2:1 handle 3: dualpi2\"")
            
            script_lines.append("echo \"Router Config Setup for datapoint " + str(index + 1) + " complete.\"")
            script_lines.append("echo \"Waiting for 30 seconds...\"")
            script_lines.append("sleep 30")
            script_lines.append("")

        except KeyError as e:
            print(f"Warning: CSV missing expected column {e} in row {index + 1}. Skipping row.")
            script_lines.append(f"# Skipping datapoint {index + 1} due to missing column: {e}")
            continue
        except Exception as e:
            print(f"Warning: Error processing row {index + 1}: {e}. Skipping row.")
            script_lines.append(f"# Skipping datapoint {index + 1} due to error: {e}")
            continue


    script_lines.append("# Clean up tc rules on the router after the loop")
    script_lines.append("ssh root@\"$router_ipaddr\" \"sudo tc qdisc del dev ens37 root 2>/dev/null || true\"")
    script_lines.append("echo \"All datapoints processed and tc rules cleaned up.\"")
    script_lines.append("exit 0")

    print("\n--- Generated Bash Script ---")
    for line in script_lines:
        print(line)
    print("--- End of Bash Script ---\n")
    print("Save the output above (starting with #!/bin/bash) into a new .sh file.")
    print("Make it executable (chmod +x your_script_name.sh) and run it.")

if __name__ == "__main__":
    # csv_path = input("Enter the path to your CSV file: ")
    csv_path = "Best_Satellite_Australia_Simulation_Log_cleaned_starlink_downlink.csv"
    generate_bash_script(csv_path)