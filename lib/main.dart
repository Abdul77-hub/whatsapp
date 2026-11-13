import 'package:flutter/material.dart';

void main() {
  runApp(const WhatsAppApp());
}

const Color whatsappGreen = Color(0xFF075E54);
const Color whatsappLightGreen = Color(0xFF25D366);
const Color whatsappBackground = Color(0xFFF0F2F5);

class WhatsAppApp extends StatelessWidget {
  const WhatsAppApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: whatsappGreen),
      ),
      home: const WhatsAppHome(),
    );
  }
}

class Chat {
  final String name;
  final String message;
  final String time;
  final String avatar;
  final int unread;
  final bool online;

  const Chat({
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    this.unread = 0,
    this.online = false,
  });
}

final List<Chat> sampleChats = [
  const Chat(
    name: 'Ahmed Mohamed',
    message: 'How are you today?',
    time: '10:45 AM',
    avatar: 'A',
    unread: 2,
    online: true,
  ),
  const Chat(
    name: 'Abdi Hassan',
    message: 'Send me the project.',
    time: '09:30 AM',
    avatar: 'H',
    unread: 1,
  ),
  const Chat(
    name: 'Mohamed Ali',
    message: 'Thank you bro!',
    time: 'Yesterday',
    avatar: 'M',
    online: true,
  ),
  const Chat(
    name: 'Family Group',
    message: 'You: Good morning everyone',
    time: 'Yesterday',
    avatar: 'F',
    unread: 5,
  ),
  const Chat(
    name: 'Abdullahi Yusuf',
    message: 'See you tomorrow.',
    time: 'Monday',
    avatar: 'Y',
  ),
  const Chat(
    name: 'Sports Management',
    message: 'New match scheduled!',
    time: 'Monday',
    avatar: 'S',
    unread: 3,
  ),
];

class WhatsAppHome extends StatefulWidget {
  const WhatsAppHome({super.key});

  @override
  State<WhatsAppHome> createState() => _WhatsAppHomeState();
}

class _WhatsAppHomeState extends State<WhatsAppHome> {
  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();

  final List<String> titles = ['WhatsApp', 'Updates', 'Communities', 'Calls'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(
            color: whatsappGreen,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ChatSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'New group', child: Text('New group')),
              const PopupMenuItem(value: 'Settings', child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          ChatsScreen(),
          StatusScreen(),
          CommunitiesScreen(),
          CallsScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: whatsappLightGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          if (selectedIndex == 0) {
            showModalBottomSheet(
              context: context,
              builder: (_) => const NewChatSheet(),
            );
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Coming soon')));
          }
        },
        child: Icon(selectedIndex == 3 ? Icons.add_call : Icons.message),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.circle_outlined),
            selectedIcon: Icon(Icons.circle),
            label: 'Updates',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Communities',
          ),
          NavigationDestination(
            icon: Icon(Icons.call_outlined),
            selectedIcon: Icon(Icons.call),
            label: 'Calls',
          ),
        ],
      ),
    );
  }
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Ask Meta AI or Search',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: whatsappBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              _filterChip('All', true),
              _filterChip('Unread', false),
              _filterChip('Favorites', false),
              _filterChip('Groups', false),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: sampleChats.length,
            itemBuilder: (context, index) {
              final chat = sampleChats[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: whatsappGreen,
                      child: Text(
                        chat.avatar,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      ),
                    ),
                    if (chat.online)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: whatsappLightGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  chat.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  chat.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat.time,
                      style: TextStyle(
                        fontSize: 11,
                        color: chat.unread > 0
                            ? whatsappLightGreen
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (chat.unread > 0)
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: whatsappLightGreen,
                        child: Text(
                          '${chat.unread}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen(chat: chat)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String text, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: Chip(
        label: Text(text),
        backgroundColor: selected ? const Color(0xFFD9FDD3) : Colors.white,
        side: BorderSide(
          color: selected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
    );
  }
}

class ChatSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search contacts';

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => _results();

  @override
  Widget buildSuggestions(BuildContext context) => _results();

  Widget _results() {
    final results = sampleChats.where(
      (chat) => chat.name.toLowerCase().contains(query.toLowerCase()),
    );

    return ListView(
      children: results.map((chat) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: whatsappGreen,
            child: Text(
              chat.avatar,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(chat.name),
          subtitle: Text(chat.message),
        );
      }).toList(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [
    {'text': 'Hello! How are you?', 'me': false, 'time': '10:30'},
    {'text': 'I am fine, thank you!', 'me': true, 'time': '10:32'},
    {'text': 'What are you doing today?', 'me': false, 'time': '10:35'},
  ];

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'text': text,
        'me': true,
        'time': TimeOfDay.now().format(context),
      });
    });

    messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: whatsappGreen,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.chat.avatar,
                style: const TextStyle(color: whatsappGreen),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.name, style: const TextStyle(fontSize: 16)),
                  Text(
                    widget.chat.online ? 'online' : 'last seen recently',
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          PopupMenuButton<String>(
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Search', child: Text('Search')),
              PopupMenuItem(value: 'Mute', child: Text('Mute')),
              PopupMenuItem(value: 'Clear', child: Text('Clear chat')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['me'] as bool;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.fromLTRB(12, 9, 9, 6),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFD9FDD3) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message['text'],
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message['time'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.done_all,
                                size: 15,
                                color: Colors.blue,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: whatsappBackground,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const AttachmentSheet(),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
                CircleAvatar(
                  backgroundColor: whatsappGreen,
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white, size: 19),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(radius: 27, child: Icon(Icons.person)),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: whatsappLightGreen,
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          title: const Text(
            'My status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Tap to add status update'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Status upload coming soon')),
            );
          },
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Recent updates',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _statusTile('Ahmed Mohamed', '10 minutes ago', 'A'),
        _statusTile('Abdi Hassan', '30 minutes ago', 'H'),
        _statusTile('Mohamed Ali', '1 hour ago', 'M'),
      ],
    );
  }

  Widget _statusTile(String name, String time, String avatar) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: whatsappLightGreen, width: 3),
        ),
        child: CircleAvatar(
          backgroundColor: whatsappGreen,
          child: Text(avatar, style: const TextStyle(color: Colors.white)),
        ),
      ),
      title: Text(name),
      subtitle: Text(time),
    );
  }
}

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.groups, size: 90, color: whatsappGreen),
          const SizedBox(height: 15),
          const Text(
            'Stay connected with communities',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text('Bring groups together in one place.'),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: whatsappGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text('New Community'),
          ),
        ],
      ),
    );
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: whatsappGreen,
            child: Icon(Icons.link, color: Colors.white),
          ),
          title: const Text('Create call link'),
          subtitle: const Text('Share a link for your WhatsApp call'),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Recent', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        _callTile('Ahmed Mohamed', 'Today, 10:30 AM', true),
        _callTile('Abdi Hassan', 'Yesterday, 8:15 PM', false),
        _callTile('Mohamed Ali', 'Monday, 4:20 PM', true),
      ],
    );
  }

  Widget _callTile(String name, String time, bool video) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: whatsappGreen,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name),
      subtitle: Row(
        children: [
          Icon(Icons.call_received, size: 15, color: whatsappLightGreen),
          const SizedBox(width: 5),
          Text(time),
        ],
      ),
      trailing: Icon(video ? Icons.videocam : Icons.call, color: whatsappGreen),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whatsappGreen,
        foregroundColor: Colors.white,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: whatsappGreen,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              'My Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Hey there! I am using WhatsApp.'),
            trailing: Icon(Icons.qr_code),
          ),
          const Divider(),
          _settingTile(
            Icons.key,
            'Account',
            'Privacy, security, change number',
          ),
          _settingTile(
            Icons.lock,
            'Privacy',
            'Control who can see your information',
          ),
          _settingTile(Icons.chat, 'Chats', 'Theme, wallpapers, chat history'),
          _settingTile(
            Icons.notifications,
            'Notifications',
            'Message and call notifications',
          ),
          _settingTile(
            Icons.storage,
            'Storage and data',
            'Network usage and storage',
          ),
          _settingTile(
            Icons.help_outline,
            'Help',
            'Help center and contact us',
          ),
          _settingTile(
            Icons.people,
            'Invite a friend',
            'Share WhatsApp with friends',
          ),
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: whatsappGreen),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {},
    );
  }
}

class NewChatSheet extends StatelessWidget {
  const NewChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'New Chat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: whatsappGreen,
              child: Icon(Icons.group, color: Colors.white),
            ),
            title: const Text('New group'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: whatsappGreen,
              child: Icon(Icons.person_add, color: Colors.white),
            ),
            title: const Text('New contact'),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class AttachmentSheet extends StatelessWidget {
  const AttachmentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.insert_drive_file, 'name': 'Document'},
      {'icon': Icons.camera_alt, 'name': 'Camera'},
      {'icon': Icons.photo, 'name': 'Gallery'},
      {'icon': Icons.headphones, 'name': 'Audio'},
      {'icon': Icons.location_on, 'name': 'Location'},
      {'icon': Icons.person, 'name': 'Contact'},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          children: items.map((item) {
            return SizedBox(
              width: 85,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item['name']} selected')),
                  );
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: whatsappGreen,
                      child: Icon(
                        item['icon'] as IconData,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(item['name'] as String),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
