import 'package:extra_care/screens/Chat/UserModel.dart';

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: ironMan,
    time: '5:30 PM',
    text: 'Hey dude! Even dead I\'m the hero. Love you 3000 guys.',
    unread: true,
  ),
  Message(
    sender: captainAmerica,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: blackWindow,
    time: '3:30 PM',
    text: 'WOW! this soul world is amazing, but miss you guys.',
    unread: false,
  ),
  Message(
    sender: spiderMan,
    time: '2:30 PM',
    text: 'I\'m exposed now. Please help me to hide my identity.',
    unread: true,
  ),
  Message(
    sender: hulk,
    time: '1:30 PM',
    text: 'HULK SMASH!!',
    unread: false,
  ),
  Message(
    sender: thor,
    time: '12:30 PM',
    text:
        'I\'m hitting gym bro. I\'m immune to mortal deseases. Are you coming?',
    unread: false,
  ),
  Message(
    sender: scarletWitch,
    time: '11:30 AM',
    text: 'My twins are giving me headache. Give me some time please.',
    unread: false,
  ),
  Message(
    sender: captainMarvel,
    time: '12:45 AM',
    text: 'You\'re always special to me nick! But you know my struggle.',
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  // Message(
  //   sender: ironMan,
  //   time: '5:30 PM',
  //   text: 'Hey dude! Event dead I\'m the hero. Love you 3000 guys.',
  //   unread: true,
  // ),
  // Message(
  //   sender: currentUser,
  //   time: '4:30 PM',
  //   text: 'We could surely handle this mess much easily if you were here.',
  //   unread: true,
  // ),
  // Message(
  //   sender: ironMan,
  //   time: '3:45 PM',
  //   text: 'Take care of peter. Give him all the protection & his aunt.',
  //   unread: true,
  // ),
  Message(
    sender: ironMan, //iron Man
    time: '3:15 PM',
    text: 'thank you very much.',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '1:30 PM',
    text: ' I am ready, Now I will move',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Your request tommorow 1:30 PM.',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '2:30 PM',
    text: 'I have a lot of work in the house that needs maintaince ',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Please enter',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '2:00 PM',
    text: 'Hello , I want to request a service ..',
    unread: true,
  ),
];
