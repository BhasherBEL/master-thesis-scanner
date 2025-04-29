import 'package:flutter/material.dart';
import 'package:thesis_scanner/pages/debug.dart';
import 'package:thesis_scanner/pages/record.dart';

class MainBar extends StatelessWidget {
	const MainBar({super.key});

	@override
	Widget build(BuildContext context) {
		return AppBar(
          title: const Text('Smart visit of Musée L'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String value) {
                  switch (value) {
                    case 'debug':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DebugPage(),
                        ),
                      );
                      break;
                    case 'experiment':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RecordPage(
                                record: record,
                                setRecord: (bool r) {
                                  setState(() {
                                    record = r;
                                  });
                                },
                                user: user,
                              ),
                        ),
                      );
                      break;
                    default:
                      break;
                  }
                
              },
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(
                      value: 'experiment',
                      child: Text('Experiment'),
                    ),
                    PopupMenuItem(value: 'debug', child: Text('Debug')),
                  ],
            ),
          ],
        )
	}
}
