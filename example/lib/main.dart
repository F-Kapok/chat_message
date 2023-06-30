import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/chat_list_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;
  late ChatController chatController;
  final List<MessageModel> _messageList = [
    MessageModel(
        ownerType: OwnerType.receiver,
        content: 'chatGpt是由OpenAi研发的连天机器人程序',
        createdAt: 1772059242000,
        id: 2,
        avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg',
        ownerName: 'ChatGPT'),
    MessageModel(
        ownerType: OwnerType.sender,
        content: '介绍一下ChatGPT',
        createdAt: 1772059241000,
        id: 1,
        avatar: 'https://o.devio.org/images/o_as/avatar/tx18.jpeg',
        ownerName: 'Kapok'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController = ChatController(
        initialMessageList: _messageList,
        scrollController: ScrollController(),
        messageWidgetBuilder: null,
        timePellet: 60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatList(
            chatController: chatController,
            onTap: (MessageModel message, BuildContext ancestor) {
              debugPrint("onTap: ${message.content}");
            },
            onPress: (MessageModel message, BuildContext ancestor) {
              debugPrint("onPress: ${message.content}");
            },
          )),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: _loadMore, child: const Text('LoadMore')),
              ElevatedButton(onPressed: _send, child: const Text('Send'))
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void _send() {
    chatController.addMessage(MessageModel(
        ownerType: OwnerType.sender,
        content: 'Hello ${count++}',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg',
        ownerName: 'Kapok'));
    Future.delayed(const Duration(milliseconds: 2000), () {
      chatController.addMessage(MessageModel(
          ownerType: OwnerType.receiver,
          content: 'chatGpt是由OpenAi研发的连天机器人程序',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg',
          ownerName: 'ChatGPT'));
    });
  }

  int _counter = 0;

  void _loadMore() {
    var tl = 1772058683000;
    tl = tl - ++_counter * 1000000;
    final List<MessageModel> messageList = [
      MessageModel(
          ownerType: OwnerType.sender,
          content: 'Hello ${_counter++}',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg',
          ownerName: 'Imooc'),
      MessageModel(
          ownerType: OwnerType.receiver,
          content: 'Nice',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg',
          ownerName: 'ChatGPT')
    ];
    chatController.loadMoreData(messageList);
  }

  Widget _diyMessageWidget(MessageModel message) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
          color: message.ownerType == OwnerType.receiver
              ? Colors.amberAccent
              : Colors.blue),
      child:
          Text('${message.ownerName} ${message.content}  ${message.avatar} '),
    );
  }
}
