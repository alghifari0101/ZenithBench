# ZenithBench (zenith.sh) 🚀

A lightweight, powerful, and professional Linux server benchmark script. This tool provides a quick and comprehensive overview of your system's hardware, disk performance, and network speed.

Developed and maintained by **Ramadi**.

## ✨ Features
* **System Information**: Detailed CPU model, cores, frequency, RAM, and Disk usage.
* **OS & Kernel**: Displays OS version, architecture, kernel version, and uptime.
* **Network & Location**: Shows Public IP, ISP (Organization), City, and Region.
* **Advanced Metrics**: Checks TCP Congestion Control and Virtualization type (KVM/OpenVZ).
* **Smart Disk I/O Test**: Runs twice for accuracy with an **Auto-Warning System** (Turns **RED** if speed is below 200 MB/s).
* **Network Speedtest**: Displays Upload, Download, and Latency in a clean table format.
* **Auto-Installer**: Automatically detects and installs missing dependencies (`curl`, `speedtest-cli`, `bc`).

## 📸 Preview
The output is formatted with professional terminal colors:
- **Cyan/Yellow**: System headers and labels.
- **Green**: High-performance metrics.
- **Red**: Low-performance warnings (Slow Disk I/O).

## 🚀 How to Use

You can run ZenithBench directly on your server using `curl`.

### Quick Execution
```bash
curl -Lso- https://raw.githubusercontent.com/alghifari0101/ZenithBench/main/zenitbench.sh | bash
