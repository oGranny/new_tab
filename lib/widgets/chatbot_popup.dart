import 'package:flutter/material.dart';
import 'package:new_tab_app/utils/gemini_api_request.dart';

class AIChatPopup extends StatefulWidget {
  final VoidCallback onClose;

  const AIChatPopup({super.key, required this.onClose});

  @override
  _AIChatPopupState createState() => _AIChatPopupState();
}

class _AIChatPopupState extends State<AIChatPopup> {
  GeminiApiRequest gemini = GeminiApiRequest();
  double dx = 1100;
  double dy = 2;
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() async {
    print("Sending message: ${_controller.text}");
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add("User: ${_controller.text}");
      });
      String response = await _generateAIResponse(_controller.text);
      setState(() {
        _messages.add("AI: $response");
        _controller.clear();
      });
    }
  }

  Future<String> _generateAIResponse(String userMessage) async {
    print(userMessage);
    return await gemini.generateContent(userMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx,
      top: dy,
      child: Draggable(
        feedback: SizedBox.shrink(),
        onDragEnd: (dragDetails) {
          setState(() {
            dx = dragDetails.offset.dx;
            dy = dragDetails.offset.dy;
          });
        },
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      dx += details.delta.dx;
                      dy += details.delta.dy;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF191515),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "  AI Chat",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isUserMessage = _messages[index].startsWith("User:");
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 5.0,
                          bottom: 5.0,
                          left: isUserMessage ? 35.0 : 20.0,
                          right: isUserMessage ? 20.0 : 35.0,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Color.fromARGB(0, 0, 0, 0)
                                : Color.fromARGB(255, 40, 37, 37),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SelectableText(
                            _messages[index].startsWith("User: ")
                                ? _messages[index].substring(6)
                                : _messages[index].substring(4),
                            textAlign: isUserMessage
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 40, 37, 37),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              onSubmitted: (value) => _sendMessage(),
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Ask Gemini",
                                // border: OutlineInputBorder(),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
