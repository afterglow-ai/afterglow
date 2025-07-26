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
  var agents = [];
  String? currentAgent;

  @override
  void initState() {
    super.initState();

    Supabase.instance.client.from('agents').select().then((data) {
      setState(() {
        agents = data;
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
              children: agents.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilledButton(
                    onPressed: () {},
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
              itemBuilder: (BuildContext context, int index) {
                return MemoryCard(
                  title: "回忆标题 $index",
                  body: "这是回忆的内容，可能会很长也可能很短。",
                  createdAt: "2023-10-01",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
