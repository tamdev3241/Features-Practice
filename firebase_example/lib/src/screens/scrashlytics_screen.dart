import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticScreen extends StatelessWidget {
  const CrashlyticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            if (FirebaseCrashlytics
                                .instance.isCrashlyticsCollectionEnabled) {
                              FirebaseCrashlytics.instance.crash();
                            }
                          },
                          child: const Text("Test"),
                        ),
                      ],
                      title: const Text(
                        "Warning",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        "After crash app, your app will be closed !!",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
                child: const Text("crash app testing"),
              ),
              ElevatedButton(
                onPressed: () {
                  throw const FormatException();
                },
                child: const Text("Faltal crash app testing"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
