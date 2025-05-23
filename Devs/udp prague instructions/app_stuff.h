#ifndef APP_STUFF_H
#define APP_STUFF_H

// app_stuff.h:
// Collecting all app related stuff in this object
//

#include <string>
#include "prague_cc.h"

// to avoid int64 printf incompatibility between platforms:
#define C_STR(i) std::to_string(i).c_str()
#define REPT_PERIOD 1000000
#define RFC8888_ACKPERIOD 25000

// app related stuff collected in this object to avoid obfuscation of the main Prague loop
struct AppStuff
{
    bool sender_role;
    // Argument parser
    bool verbose;
    bool quiet;
    const char *rcv_addr;
    uint32_t rcv_port;
    bool connect;
    size_tp max_pkt;
    rate_tp max_rate;
    // state for verbose reporting
    time_tp data_tm;        // send diff reference
    time_tp ack_tm;         // ack diff reference
    // state for default (non-quiet) reporting
    time_tp rept_tm;        // timer for reporting interval
    rate_tp acc_bytes_sent; // accumulated bytes sent
    rate_tp acc_bytes_rcvd; // accumulated bytes received
    rate_tp acc_rtts;       // accumulated rtts to calculate the average
    count_tp count_rtts;    // count the RTT reports
    count_tp prev_pkts;     // prev packets received
    count_tp prev_marks;    // prev marks received
    count_tp prev_losts;    // prev losts received
    bool rfc8888_ack;
    uint32_t rfc8888_ackperiod;

    void ExitIf(bool stop, const char* reason)
    {
        if (stop) {
            perror(reason);
            exit(1);
        }
    }
    AppStuff(bool sender, int argc, char **argv):
        sender_role(sender), verbose(false), quiet(false), rcv_addr("0.0.0.0"), rcv_port(8080), connect(false),
        max_pkt(PRAGUE_INITMTU), max_rate(PRAGUE_MAXRATE), data_tm(1), ack_tm(1), rept_tm(REPT_PERIOD),
        acc_bytes_sent(0), acc_bytes_rcvd(0), acc_rtts(0), count_rtts(0), prev_pkts(0), prev_marks(0), prev_losts(0),
        rfc8888_ack(false), rfc8888_ackperiod(RFC8888_ACKPERIOD)
    {
        parseArgs(argc, argv);
        printInfo();
    }
    void parseArgs(int argc, char** argv)
    {
        const char *def_rcv_addr = rcv_addr;
        for (int i = 1; i < argc; ++i) {
            std::string arg = argv[i];
            if (arg == "-a" && i + 1 < argc) {
                rcv_addr = argv[++i];
            } else if (arg == "-b" && i + 1 < argc) {
                errno = 0;
                char *p;
                max_rate = strtoull(argv[++i], &p, 10) * 125; // from kbps to B/s
                ExitIf(errno != 0 || *p != '\0', "Error during converting max bitrate");
            } else if (arg == "-p" && i + 1 < argc) {
                errno = 0;
                char *p;
                rcv_port = strtoul(argv[++i], &p, 10);
                // Print the result
                printf("Received port: %u\n", rcv_port);
                ExitIf(errno != 0 || *p != '\0' || rcv_port > 65535, "Error during converting max port");
            } else if (arg == "-c") {
                connect = true;
            } else if (arg == "-m" && i + 1 < argc) {
                char *p;
                max_pkt = strtoull(argv[++i], &p, 10);
                ExitIf(errno != 0 || *p != '\0', "Error during converting max packet size");
            } else if (arg == "-v") {
                verbose = true;
                quiet = true;
            } else if (arg == "-q") {
                quiet = true;
            } else if (arg == "--rfc8888") {
                rfc8888_ack = true;
            } else if (arg == "--rfc8888ackperiod") {
                char *p;
                rfc8888_ackperiod = strtoul(argv[++i], &p, 10);
                ExitIf(errno != 0 || *p != '\0', "Error during converting RFC8888 ACK period");
            } else {
                printf("UDP Prague %s usage:\n"
                    "    -a <IP address, def: 0.0.0.0 or 127.0.0.1 if client>\n"
                    "    -p <server port, def: 8080>\n"
                    "    -c (connect first as a client, otherwise bind and wait for connection)\n"
                    "    -b <sender specific max bitrate, def: %s kbps>\n"
                    "    -m <max packet/ACK size, def: %s B>\n"
                    "    -v (for verbose prints)\n"
                    "    -q (quiet)\n"
                    "    --rfc8888 (RFC8888 feddback)"
                    "    --rfc8888ackperiod <RFC8888 ACK period, def %s ms>",
                    sender_role ? "sender" : "receiver", C_STR(PRAGUE_MAXRATE / 125), C_STR(PRAGUE_INITMTU), C_STR(RFC8888_ACKPERIOD / 1000));
                exit(1);
            }
        }
        if (connect && (rcv_addr == def_rcv_addr))
            rcv_addr = "127.0.0.1";
        if (max_rate < PRAGUE_MINRATE || max_rate > PRAGUE_MAXRATE)
            max_rate = PRAGUE_MAXRATE;
    }
    void printInfo()
    {
        printf("UDP Prague %s %s %s on port %d with max packet size %s bytes.\n",
            sender_role ? "sender" : "receiver",
            connect ? "connecting to" : "listening at",
            rcv_addr, rcv_port, C_STR(max_pkt));
        if (verbose) {
            if (sender_role) {
                printf("s: time, timestamp, echoed_timestamp, time_diff, seqnr, packet_size,,,,, "
                    "pacing_rate, packet_window, packet_burst, inflight, inburst, nextSend\n");
                printf("r: time, timestamp, echoed_timestamp, time_diff, seqnr, bytes_received, packets_received, packets_CE, packets_lost, error_L4S,,,,, "
                    "inflight, inburst, nextSend\n");
            } else {
                printf("r: time, timestamp, echoed_timestamp, time_diff, seqnr, bytes_received\n");
                printf("s: time, timestamp, echoed_timestamp, time_diff, seqnr, packet_size, packets_received, packets_CE, packets_lost, error_L4S\n");
            }
        }
    }
    void LogSendData(time_tp now, time_tp timestamp, time_tp echoed_timestamp, count_tp seqnr, size_tp packet_size,
        rate_tp pacing_rate, count_tp packet_window, count_tp packet_burst, count_tp inflight, count_tp inburst, time_tp nextSend)
    {
        if (verbose) {
            // "s: time, timestamp, echoed_timestamp, time_diff, seqnr, packet_size,,,,, "
            // "pacing_rate, packet_window, packet_burst, inflight, inburst, nextSend"
            printf("s: %d, %d, %d, %d, %d, %s,,,,, %s, %d, %d, %d, %d, %d\n",
                now, timestamp, echoed_timestamp, timestamp - data_tm, seqnr, C_STR(packet_size),
                C_STR(pacing_rate), packet_window, packet_burst, inflight, inburst, nextSend - now);
            data_tm = timestamp;
        }
        if (!quiet) acc_bytes_sent += packet_size;
    }
    void LogRecvACK(time_tp now, time_tp timestamp, time_tp echoed_timestamp, count_tp seqnr, size_tp bytes_received,
        count_tp packets_received, count_tp packets_CE, count_tp packets_lost, bool error_L4S,
        rate_tp pacing_rate, count_tp packet_window, count_tp packet_burst, count_tp inflight, count_tp inburst, time_tp nextSend)
    {
        if (verbose) {
            // "r: time, timestamp, echoed_timestamp, time_diff, seqnr, bytes_received, packets_received, packets_CE, packets_lost, error_L4S,,,,, "
            // "inflight, inburst, nextSend"
            printf("r: %d, %d, %d, %d, %d, %s, %d, %d, %d, %d,,,,, %d, %d, %d\n",
                now, timestamp, echoed_timestamp, timestamp - ack_tm, seqnr, C_STR(bytes_received), packets_received, packets_CE, packets_lost,
                error_L4S, inflight, inburst, nextSend - now);
            ack_tm = timestamp;
            acc_bytes_rcvd += bytes_received;
            acc_rtts += (now - echoed_timestamp);
            count_rtts++;
            // Display sender side info
            if (now - rept_tm >= 0)
                PrintSender(now, packets_received, packets_CE, packets_lost, pacing_rate, packet_window, packet_burst, inflight, inburst);
        }
        if (!quiet) {
            acc_bytes_rcvd += bytes_received;
            acc_rtts += (now - echoed_timestamp);
            count_rtts++;
            // Display sender side info
            if (now - rept_tm >= 0)
                PrintSender(now, packets_received, packets_CE, packets_lost, pacing_rate, packet_window, packet_burst, inflight, inburst);
        }
    }
    void LogRecvRFC8888ACK(time_tp now, count_tp seqnr, size_tp bytes_received, count_tp begin_seq, uint16_t num_reports,
        uint16_t num_rtt, time_tp *pkts_rtt, count_tp packets_received, count_tp packets_CE, count_tp packets_lost, bool error_L4S,
        rate_tp pacing_rate, count_tp packet_window, count_tp packet_burst, count_tp inflight, count_tp inburst, time_tp nextSend)
    {
        if (verbose) {
            // "r: time, begin_seq, num_reports, time_diff, seqnr, bytes_received, packets_received, packets_CE, packets_lost, error_L4S,,,,, "
            // "inflight, inburst, nextSend"
            printf("r: %d, %d, %d, %d, %d, %s, %d, %d, %d, %d,,,,, %d, %d, %d\n",
                now, begin_seq, num_reports, now - ack_tm, seqnr, C_STR(bytes_received), packets_received, packets_CE, packets_lost,
                error_L4S, inflight, inburst, nextSend - now);
            ack_tm = now;
            acc_bytes_rcvd += bytes_received;
            for (uint16_t i = 0; i < num_rtt; i++) {
                acc_rtts += pkts_rtt[i];
            }
            count_rtts += num_rtt;
            // Display sender side info
            if (now - rept_tm >= 0)
                PrintSender(now, packets_received, packets_CE, packets_lost, pacing_rate, packet_window, packet_burst, inflight, inburst);
        }
        if (!quiet) {
            acc_bytes_rcvd += bytes_received;
            for (uint16_t i = 0; i < num_rtt; i++) {
                acc_rtts += pkts_rtt[i];
            }
            count_rtts += num_rtt;
            // Display sender side info
            if (now - rept_tm >= 0)
                PrintSender(now, packets_received, packets_CE, packets_lost, pacing_rate, packet_window, packet_burst, inflight, inburst);
        }
    }
    void PrintSender(time_tp now, count_tp packets_received, count_tp packets_CE, count_tp packets_lost,
        rate_tp pacing_rate, count_tp packet_window, count_tp packet_burst, count_tp inflight, count_tp inburst)
    {
        float rate_rcvd = 8.0f * acc_bytes_rcvd / (now - rept_tm + REPT_PERIOD);
        float rate_sent = 8.0f * acc_bytes_sent / (now - rept_tm + REPT_PERIOD);
        float rate_pacing = 8.0f * pacing_rate / 1000000.0;
        float rtt = (count_rtts > 0) ? 0.001f * acc_rtts / count_rtts : 0.0f;
        float mark_prob = (packets_received - prev_pkts > 0) ? 100.0f * (packets_CE - prev_marks) / (packets_received - prev_pkts) : 0.0f;
        float loss_prob = (packets_received - prev_pkts > 0) ? 100.0f * (packets_lost - prev_losts) / (packets_received - prev_pkts) : 0.0f;
        printf("[SENDER]: %.2f sec, Sent: %.3f Mbps, Rcvd: %.3f Mbps, RTT: %.3f ms, "
            "Mark: %.2f%%(%d/%d), Lost: %.2f%%(%d/%d), Pacing rate: %.3f Mbps, InFlight/W: %d/%d packets, InBurst/B: %d/%d packets\n",
            now / 1000000.0f, rate_sent, rate_rcvd, rtt,
            mark_prob, packets_CE - prev_marks, packets_received - prev_pkts,
            loss_prob, packets_lost - prev_losts, packets_received - prev_pkts, rate_pacing, inflight, packet_window, inburst, packet_burst);
        rept_tm = now + REPT_PERIOD;
        acc_bytes_sent = 0;
        acc_bytes_rcvd = 0;
        acc_rtts = 0;
        count_rtts = 0;
        prev_pkts = packets_received;
        prev_marks = packets_CE;
        prev_losts = packets_lost;
    }
    void LogRecvData(time_tp now, time_tp timestamp, time_tp echoed_timestamp, count_tp seqnr, size_tp bytes_received)
    {
        if (verbose) {
            // "r: time, timestamp, echoed_timestamp, time_diff, seqnr, bytes_received"
            printf("r: %d, %d, %d, %d, %d, %s\n",
                now, timestamp, echoed_timestamp, timestamp - data_tm, seqnr, C_STR(bytes_received));
            data_tm = timestamp;
        }
        if (!quiet) {
            acc_bytes_rcvd += bytes_received;
            if (echoed_timestamp && !rfc8888_ack) {
                acc_rtts += (now - echoed_timestamp);
                count_rtts++;
            }
        }
    }
    void LogSendACK(time_tp now, time_tp timestamp, time_tp echoed_timestamp, count_tp seqnr, size_tp packet_size,
        count_tp packets_received, count_tp packets_CE, count_tp packets_lost, bool error_L4S)
    {
        if (verbose) {
            // "s: time, timestamp, echoed_timestamp, time_diff, seqnr, packet_size, packets_received, packets_CE, packets_lost, error_L4S"
            printf("s: %d, %d, %d, %d, %d, %s, %d, %d, %d, %d\n",
                now, timestamp, echoed_timestamp, timestamp - ack_tm, seqnr, C_STR(packet_size), packets_received, packets_CE, packets_lost, error_L4S);
            ack_tm = timestamp;
            acc_bytes_sent += packet_size;
            if (now - rept_tm >= 0)
                PrintReceiver(now, packets_received, packets_CE, packets_lost);
        }
        if (!quiet) {
            // Display receiver side info
            acc_bytes_sent += packet_size;
            if (now - rept_tm >= 0)
                PrintReceiver(now, packets_received, packets_CE, packets_lost);
        }
    }
    void LogSendRFC8888ACK(time_tp now, count_tp seqnr, size_tp packet_size, count_tp begin_seq, uint16_t num_reports, uint16_t *report)
    {
        if (verbose) {
            // "s: time, time_diff, seqnr, packet_size, begin_seq, num_reports, packets_received, packets_CE, packets_lost, error_L4S"
            printf("s: %d, %d, %d, %s, %d, %d, \n",
                now, now - ack_tm, seqnr, C_STR(packet_size), begin_seq, num_reports);
            ack_tm = now;
        }
        if (!quiet) {
            // Display receiver side info
            acc_bytes_sent += packet_size;
            for (uint16_t i = 0; i < num_reports; i++) {
                if ((htons(report[i]) & 0x8000) >> 15) {
                    acc_rtts += ((htons(report[i]) & 0x1FFF) << 10);
                    prev_pkts += 1;
                    prev_marks += ((htons(report[i]) & 0x6000) >> 13 == 0x3);
                    count_rtts++;
                } else {
                    prev_losts += 1;
                }
            }
            if (now - rept_tm >= 0)
                PrintReceiver(now, 0, 0, 0);
        }
    }
    void PrintReceiver(time_tp now, count_tp packets_received = 0, count_tp packets_CE = 0, count_tp packets_lost = 0)
    {
        float rate_rcvd = 8.0f * acc_bytes_rcvd / (now - rept_tm + REPT_PERIOD);
        float rate_sent = 8.0f * acc_bytes_sent / (now - rept_tm + REPT_PERIOD);
        float rtt = (count_rtts > 0) ? 0.001f * acc_rtts / count_rtts : 0.0f;
        float mark_prob = (!rfc8888_ack) ? ((packets_received - prev_pkts > 0) ? 100.0f * (packets_CE - prev_marks) / (packets_received - prev_pkts) : 0.0f)
                                         : ((prev_pkts > 0) ? 100.0f * (prev_marks) / (prev_pkts) : 0.0f);
        float loss_prob = (!rfc8888_ack) ? ((packets_received - prev_pkts > 0) ? 100.0f * (packets_lost - prev_losts) / (packets_received - prev_pkts) : 0.0f)
                                         : ((prev_pkts > 0) ? 100.0f * (prev_losts) / (prev_pkts) : 0.0f);
        printf("[RECVER]: %.2f sec, Rcvd: %.3f Mbps, Sent: %.3f Mbps, %s: %.3f ms, Mark: %.2f%%(%d/%d), Lost: %.2f%%(%d/%d)\n",
            now / 1000000.0f, rate_rcvd, rate_sent, (!rfc8888_ack)? "RTT": "ATO", rtt,
            mark_prob, (!rfc8888_ack) ? (packets_CE - prev_marks) : prev_marks, (!rfc8888_ack) ? (packets_received - prev_pkts) : prev_pkts,
            loss_prob, (!rfc8888_ack) ? (packets_lost - prev_losts) : prev_losts, (!rfc8888_ack) ? (packets_received - prev_pkts) : prev_pkts);
        
        rept_tm = now + REPT_PERIOD;
        acc_bytes_rcvd = 0;
        acc_bytes_sent = 0;
        acc_rtts = 0;
        count_rtts = 0;
        prev_pkts = (!rfc8888_ack) ? packets_received : 0;
        prev_marks = (!rfc8888_ack) ? packets_CE : 0;
        prev_losts = (!rfc8888_ack) ? packets_lost : 0;
    }
};

#endif //APP_STUFF_H
