import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sendream/widgets/letter_container.dart';

int selectedAgentId = 0;

class ContactSelector extends StatelessWidget {
  final VoidCallback onBack;
  final Function(dynamic) onNavBack;

  const ContactSelector({
    super.key,
    required this.onBack,
    required this.onNavBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FutureBuilder(
              future: Supabase.instance.client.from("agents").select(),
              builder: (context, snapshot) {
                final data = snapshot.data;

                if (data?.isEmpty ?? true) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "选择联系人",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    ...data!.map(
                      (e) => Padding(
                        padding: EdgeInsets.all(2),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            selectedAgentId = e["id"];
                            Navigator.of(context)
                                .push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => LetterContainer(
                                          name: e["name"],
                                          agentId: e["id"],
                                        ),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                    transitionDuration: Duration(
                                      milliseconds: 500,
                                    ),
                                  ),
                                )
                                .then(onNavBack);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  e["name"] ?? "未知",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        FilledButton(
          onPressed: onBack,
          child: SizedBox(
            width: double.infinity,
            child: Center(child: Text("返回上一步")),
          ),
        ),
      ],
    );
  }
}
