import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final message = _messageController.text;
    _messageController.clear();

    setState(() => _isLoading = true);

    try {
      final response = await _chatService.sendMessage(message);
      print('Response: $response');
      
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)),
        );
    } catch (e) {
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
    } finally {
      
        setState(() => _isLoading = false);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                const Text(
                  'Ask me anything!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
