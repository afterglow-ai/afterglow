import 'package:flutter/material.dart';
import 'package:sendream/widgets/book_container.dart';
import 'package:sendream/widgets/memory_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  var agentAndMessages = [];
  int currentAgentIndex = 0;

  @override
  void initState() {
    super.initState();

    Supabase.instance.client
        .from('agents')
        .select("*, messages(*)")
        .eq("messages.saved", true)
        .then((data) {
          print("Fetched agents and messages: $data");
          setState(() {
            agentAndMessages = data;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BookContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("回忆", style: TextStyle(fontSize: 24, color: Colors.black)),
          SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: agentAndMessages.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        currentAgentIndex = agentAndMessages.indexOf(e);
                      });
                    },
                    child: Text(
                      e['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: WaterfallFlow.builder(
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: currentAgentIndex < agentAndMessages.length
                  ? agentAndMessages[currentAgentIndex]['messages'].length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                final message =
                    agentAndMessages[currentAgentIndex]['messages'][index];

                final title = "这是第 ${index + 1} 封信";
                return MemoryCard(
                  title: (message["role"] == "user" ? "【送信】" : "【回信】") + title,
                  body: message['content'],
                  createdAt: message['created_at'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
