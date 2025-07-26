import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendream/consts.dart';
import 'package:sendream/dify.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class LetterContainer extends StatefulWidget {
  final String? name;
  final int? agentId;
  const LetterContainer({super.key, this.name, this.agentId});

  @override
  State<LetterContainer> createState() => _LetterContainerState();
}

class _LetterContainerState extends State<LetterContainer> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController controller = TextEditingController();
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('选择图片失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/bg0.png"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: _isLoading ? null : _pickImage,
          elevation: 0,
          shape: CircleBorder(),
          backgroundColor: _isLoading ? Colors.grey : Color(0xFFFF8B8B),
          child: Icon(Icons.photo_rounded, color: Colors.white),
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(24),
              constraints: BoxConstraints.expand(),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.primary, width: 8),
                ),
                color: Color(0xFFFFF0F0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close, color: Color(0xFFFF8B8B)),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          if (controller.text.isEmpty) {
                            return;
                          }
                          setState(() {
                            controller.text = "";
                          });
                        },
                        icon: Icon(Icons.backspace, color: Color(0xFFFF8B8B)),
                      ),
                      SizedBox(width: 8),
                      FilledButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (controller.text.isEmpty) {
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final client = Supabase.instance.client;
                                  final result = await client
                                      .from("agents")
                                      .select()
                                      .eq("id", widget.agentId!)
                                      .single();
                                  String? imageUrl;
                                  if (_selectedImage != null) {
                                    imageUrl =
                                        "https://rnawadrbuzmcdwacourg.supabase.co/storage/v1/object/public/${await Supabase.instance.client.storage.from("pic").upload(Uuid().v4(), File(_selectedImage!.path))}";
                                  }

                                  // 保存到 supabase
                                  await client.from("messages").insert({
                                    "agent": widget.agentId,
                                    "content": controller.text,
                                    "image_url": imageUrl,
                                    "role": "user",
                                    "user_id": Supabase
                                        .instance
                                        .client
                                        .auth
                                        .currentUser
                                        ?.id,
                                    "saved": true,
                                  });

                                  globalDifyResponse = chatWithDify(
                                    result["prompt"],
                                    result["name"],
                                    controller.text,
                                    imageUrl,
                                  );
                                  navPageKey.currentState?.changeBg(2);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('发送失败: $e')),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Center(child: Text("发送")),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 15.0,
                      vertical: 4,
                    ),
                    child: Text(
                      "To: 亲爱的${widget.name ?? ""}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 显示选中的图片
                  if (_selectedImage != null)
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15.0,
                        vertical: 8,
                      ),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15.0,
                        vertical: 4,
                      ),
                      child: TextField(
                        maxLines: null,
                        expands: true,
                        controller: controller,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "在这里写下你的信件内容...",
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Loading overlay
            if (_isLoading)
              Container(
                margin: const EdgeInsets.all(24),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.black54,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF8B8B),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "正在发送...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
