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

class _MemoryPageState extends State<MemoryPage>
    with SingleTickerProviderStateMixin {
  var agentAndMessages = [];
  int currentAgentIndex = 0;
  var currentMessage;
  String? currentMessageTitle;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Supabase.instance.client
        .from('agents')
        .select("*, messages(*)")
        .eq("messages.saved", true)
        .then((data) {
          print("Fetched agents and messages: $data");
          setState(() {
            agentAndMessages = data;
          });
          _animationController.forward();
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (agentAndMessages.isEmpty) {
      return Center(child: Text("没有找到任何回忆"));
    }

    if (currentMessage != null) {
      return BookContainer(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _animationController.reverse().then((_) {
                        setState(() {
                          currentMessage = null;
                          currentMessageTitle = null;
                        });
                        _animationController.forward();
                      });
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ],
              ),
              Text(
                currentMessage["role"] == "user"
                    ? "【送信】${currentMessageTitle!}"
                    : "【回信】${currentMessageTitle!}",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              // 时间
              Text(
                currentMessage['created_at'] != null
                    ? DateTime.parse(
                        currentMessage['created_at'],
                      ).toLocal().toString().substring(0, 19)
                    : "",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (currentMessage['image_url'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.network(
                    currentMessage['image_url'],
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              SizedBox(height: 16),
              Text(
                currentMessage['content'],
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      );
    }

    return BookContainer(
      child: FadeTransition(
        opacity: _fadeAnimation,
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
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
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
                  return InkWell(
                    onTap: () {
                      _animationController.reverse().then((_) {
                        setState(() {
                          currentMessage = message;
                          currentMessageTitle = title;
                        });
                        _animationController.forward();
                      });
                    },
                    child: MemoryCard(
                      title:
                          (message["role"] == "user" ? "【送信】" : "【回信】") + title,
                      body: message['content'],
                      createdAt: DateTime.parse(
                        message['created_at'],
                      ).toLocal().toString().substring(0, 19),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
