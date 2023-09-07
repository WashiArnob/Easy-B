import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          NotificationItem(
            title: 'New Order',
            description: 'You have a new order from John Doe',
            time: '2 hours ago',
            icon: Icons.shopping_cart,
          ),
          SizedBox(height: 16.0),
          NotificationItem(
            title: 'Payment Received',
            description: 'Payment received from Jane Smith',
            time: '4 hours ago',
            icon: Icons.attach_money,
          ),
          SizedBox(height: 16.0),
          NotificationItem(
            title: 'Upcoming Meeting',
            description: 'Reminder: Meeting with clients at 10:00 AM',
            time: 'Today, 9:30 AM',
            icon: Icons.calendar_today,
          ),
          SizedBox(height: 16.0),
          NotificationItem(
            title: 'New Message',
            description: 'You have a new message from David Johnson',
            time: 'Yesterday, 6:45 PM',
            icon: Icons.mail,
          ),
          SizedBox(height: 16.0),
          NotificationItem(
            title: 'Product Update',
            description: 'New product added to the inventory',
            time: '2 days ago',
            icon: Icons.update,
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;

  const NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: Text(
          time,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
