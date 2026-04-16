// import 'dart:io';
// import 'dart:async'; // Required for Timer if you add heartbeats later
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PLCController extends GetxController {
//   var isConnected = false.obs;
//   var isConnecting = false.obs;
//   var connectedIp = "".obs;
//   var connectedPort = "".obs;
//   var debugStatus = "Idle".obs;

//  final ipController = TextEditingController();
//   final portController = TextEditingController();
//   Socket? _socket;

//   // CRITICAL: This ensures the socket is killed when the controller is
//   // removed from memory (e.g., during navigation or hot restart).
//   Future<void> connectToPLC(String ip, String port) async {
//   if (isConnecting.value) return;

//   // 1. Force a clean state
//   await _cleanupBeforeConnect();

//   int? portNum = int.tryParse(port);
//   if (portNum == null) return;

//   try {
//     isConnecting.value = true;
//     debugStatus.value = "Connecting...";

//     // 2. USE ADVANCED SOCKET OPTIONS
//     _socket = await Socket.connect(
//       ip,
//       portNum,
//       timeout: const Duration(seconds: 4)
//     );

//     // This prevents the "sticky" connection behavior
//     _socket!.setOption(SocketOption.tcpNoDelay, true);

//     isConnected.value = true;
//     debugStatus.value = "Connected";

//     _socket!.listen(
//       (data) => print("Data: $data"),
//       onError: (err) => disconnect(),
//       onDone: () => disconnect(),
//       cancelOnError: true,
//     );

//   } catch (e) {
//     print("Connect Error: $e");
//     disconnect();
//   } finally {
//     isConnecting.value = false;
//   }
// }

// Future<void> _cleanupBeforeConnect() async {
//   print("DEBUG: Force cleaning socket state...");

//   // 1. Reset observables
//   isConnected.value = false;
//   debugStatus.value = "Resetting...";

//   // 2. Kill the socket and its background resources
//   if (_socket != null) {
//     _socket!.destroy();
//     _socket = null;
//   }

//   // 3. IMPORTANT: Wait for the OS to release the socket handle.
//   // 500ms is usually enough for the network stack to clear 'TIME_WAIT' status.
//   await Future.delayed(const Duration(milliseconds: 500));
// }

//   void disconnect() {
//     print("DEBUG: Disconnecting Socket and resetting state...");
//     _socket?.destroy();
//     _socket = null;
//     isConnected.value = false;
//     debugStatus.value = "Disconnected";
//   }
// }
// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PLCController extends GetxController {
//   var isConnected = false.obs;
//   var isConnecting = false.obs;
//   var connectedIp = "".obs;
//   var connectedPort = "".obs;
//   var debugStatus = "Idle".obs;

//   // Storing the read value from the PLC
//   var plcDataValue = 0.obs;

//   final ipController = TextEditingController();
//   final portController = TextEditingController();
//   Socket? _socket;

//   Future<void> connectToPLC(String ip, String port) async {
//     if (isConnecting.value) return;
//     await _cleanupBeforeConnect();

//     int? portNum = int.tryParse(port);
//     if (portNum == null) return;

//     try {
//       isConnecting.value = true;
//       debugStatus.value = "Connecting...";

//       _socket = await Socket.connect(ip, portNum, timeout: const Duration(seconds: 4));
//       _socket!.setOption(SocketOption.tcpNoDelay, true);

//       isConnected.value = true;
//       debugStatus.value = "Connected";

//       _socket!.listen(
//         (data) => _handleResponse(data), // Custom handler for responses
//         onError: (err) => disconnect(),
//         onDone: () => disconnect(),
//         cancelOnError: true,
//       );

//     } catch (e) {
//       debugStatus.value = "Connect Error";
//       disconnect();
//     } finally {
//       isConnecting.value = false;
//     }
//   }

//   // --- SEND COMMAND METHOD ---
//  void sendCustomHexRequest() {
//   if (_socket != null && isConnected.value) {
//     // Your exact Modbus TCP frame
//     List<int> mbusFrame = [0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x01, 0x03, 0x00, 0x00, 0x00, 0x01];

//     _socket!.add(mbusFrame);

//     // This converts [0, 1, 10] into "00 01 0A"
//     String hexString = mbusFrame
//         .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
//         .join(' ');

//     print("SENT: $hexString");
//     debugStatus.value = "Sent: $hexString";
//   }
// }

//   // --- GET RESPONSE METHOD ---
//  void _handleResponse(List<int> data) {
//   // Convert the raw bytes to a Hex String
//   String hexResponse = data
//       .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
//       .join(' ');

//   print("RESPONSE: $hexResponse");

//   // Logic to extract the value (still using the byte indices)
//   if (data.length >= 11 && data[7] == 0x03) {
//     int value = (data[9] << 8) | data[10];
//     plcDataValue.value = value;

//     // Show the hex value in the status too
//     String hexVal = value.toRadixString(16).padLeft(4, '0').toUpperCase();
//     debugStatus.value = "Value: $value (Hex: $hexVal)";
//   }
// }

//   Future<void> _cleanupBeforeConnect() async {
//     isConnected.value = false;
//     if (_socket != null) {
//       _socket!.destroy();
//       _socket = null;
//     }
//     await Future.delayed(const Duration(milliseconds: 500));
//   }

//   void disconnect() {
//     _socket?.destroy();
//     _socket = null;
//     isConnected.value = false;
//     debugStatus.value = "Disconnected";
//   }
// }
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PLCController extends GetxController {
  var isConnected = false.obs;
  var isConnecting = false.obs;
  var debugStatus = "Idle".obs;
  var plcDataValue = 0.obs;

  final ipController = TextEditingController();
  final portController = TextEditingController();
  Socket? _socket;

  // --- 1. MODBUS CRC-16 CALCULATION ---
  List<int> _calculateModbusCRC(List<int> data) {
    int crc = 0xFFFF;
    for (int byte in data) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x0001) != 0) {
          crc = (crc >> 1) ^ 0xA001;
        } else {
          crc >>= 1;
        }
      }
    }
    return [crc & 0xFF, (crc >> 8) & 0xFF]; // Returns [LowByte, HighByte]
  }

  // --- 2. CONNECTION LOGIC ---
  Future<void> connectToPLC(String ip, String port) async {
    if (isConnecting.value) return;
    await _cleanupBeforeConnect();

    int? portNum = int.tryParse(port);
    if (portNum == null) return;

    try {
      isConnecting.value = true;
      debugStatus.value = "Connecting...";
      _socket = await Socket.connect(ip, portNum,
          timeout: const Duration(seconds: 4));
      _socket!.setOption(SocketOption.tcpNoDelay, true);

      isConnected.value = true;
      debugStatus.value = "Connected";

      _socket!.listen(
        (data) => _handleResponse(data),
        onError: (err) => disconnect(),
        onDone: () => disconnect(),
        cancelOnError: true,
      );
    } catch (e) {
      debugStatus.value = "Connect Error";
      disconnect();
    } finally {
      isConnecting.value = false;
    }
  }

  // --- 3. MODBUS RTU READ COMMAND ---
  void sendGeneratorDataRequest() {
    if (_socket == null || !isConnected.value) return;

    // The exact frame you requested:
    // 02 (Slave) | 04 (Func) | 00 0F (Addr) | 00 0D (Count)
    List<int> frame = [0x01, 0x03, 0x00, 0x01, 0x00, 0x01];

    // Calculate CRC for this specific frame
    List<int> crc = _calculateModbusCRC(frame);

    // finalPacket = [02, 04, 00, 0F, 00, 0D, CRC_Low, CRC_High]
    List<int> finalPacket = [...frame, ...crc];

    _socket!.add(finalPacket);
    _printHex("SENT RTU", finalPacket);
  }

  void _handleResponse(List<int> data) {
    _printHex("RESPONSE RTU", data);

    // For a single register read, the response is exactly 7 bytes long
    // Index 0: Slave ID
    // Index 1: Function Code (0x03)
    // Index 2: Byte Count (0x02)
    // Index 3: Data High Byte
    // Index 4: Data Low Byte
    // Index 5-6: CRC

    if (data.length >= 5 && data[1] == 0x03) {
      int highByte = data[3];
      int lowByte = data[4];
      int value = (highByte << 8) | lowByte;

      plcDataValue.value = value;
      debugStatus.value = "Value: $value";
      print("Decoded RTU Value: $value from Slave: ${data[0]}");
    }
  }

  void _printHex(String label, List<int> data) {
    String hex = data
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');
    print("$label: $hex");
  }

  void disconnect() {
    _socket?.destroy();
    _socket = null;
    isConnected.value = false;
    debugStatus.value = "Disconnected";
  }

  Future<void> _cleanupBeforeConnect() async {
    isConnected.value = false;
    if (_socket != null) {
      _socket!.destroy();
      _socket = null;
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
