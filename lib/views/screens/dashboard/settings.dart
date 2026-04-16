import 'package:autopeepal/logic/controller/dashboard/settingsController.dart'; // Ensure PLCController is here
import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  // Inject/Find the Controller
  final PLCController plcController = Get.put(PLCController(), permanent: true);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return SafeArea(
      child: MainLayout(
        title: "Network Configuration",
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 40 : 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PLC Connection Settings",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),

                // IP Address Field
                TextFormField(
                  controller: plcController.ipController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'PLC IP Address',
                    hintText: "192.168.3.250",
                    prefixIcon: Icon(Icons.lan),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Port Field
                TextFormField(
                  controller: plcController.portController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    hintText: "502",
                    prefixIcon: Icon(Icons.settings_input_component),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 40),

                // Reactive Connection Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: plcController.isConnecting.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  // 1. Force a clean disconnect first
                                  plcController.disconnect();

                                  // 2. Small delay to let the OS clear the socket
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));

                                  // 3. Reconnect
                                  plcController.connectToPLC(
                                      plcController.ipController.text,
                                      plcController.portController.text);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A5A71),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: plcController.isConnecting.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                plcController.isConnected.value
                                    ? 'RECONNECT DEVICE'
                                    : 'CONNECT TO PLC',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    )),

                const SizedBox(height: 20),

                // Live Status Indicator
                Obx(() => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: plcController.isConnected.value
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: plcController.isConnected.value
                                ? Colors.green
                                : Colors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            plcController.isConnected.value
                                ? Icons.check_circle
                                : Icons.error_outline,
                            color: plcController.isConnected.value
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Device Status: ${plcController.isConnected.value ? 'ONLINE' : 'OFFLINE'}",
                            style: TextStyle(
                              color: plcController.isConnected.value
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 10),
                // Debug Log Display
                Obx(() => Text(
                      "Debug: ${plcController.debugStatus.value}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )),
                    const SizedBox(height: 20),

ElevatedButton(
  onPressed: plcController.isConnected.value ? () => plcController.sendGeneratorDataRequest() : null,
  child: const Text("Read D0 Register"),
),

Obx(() => Text(
  "PLC D0 Value: ${plcController.plcDataValue.value}",
  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
