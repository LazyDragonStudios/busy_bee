import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Calendar Integration',
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  auth.AutoRefreshingAuthClient? _client;
  calendar.CalendarApi? _calendarApi;

  @override
  void initState() {
    super.initState();
    _authenticateGoogle();
  }

  // Method to authenticate using OAuth 2.0
  Future<void> _authenticateGoogle() async {
    final clientId = auth.ClientId('<YOUR_CLIENT_ID>.apps.googleusercontent.com', '<YOUR_CLIENT_SECRET>');
    final scopes = [calendar.CalendarApi.calendarScope];

    try {
      _client = await auth.clientViaUserConsent(clientId, scopes, _promptUserForConsent);
      _calendarApi = calendar.CalendarApi(_client!);
      fetchGoogleCalendarEvents();
    } catch (e) {
      print("Error during authentication: $e");
    }
  }

  // Prompt user to authenticate with Google
  void _promptUserForConsent(String url) {
    // Open the URL in a web browser to authenticate the user
    print('Please visit the following URL to authenticate: $url');
  }

  // Fetch Google Calendar events
  Future<void> fetchGoogleCalendarEvents() async {
    if (_calendarApi != null) {
      try {
        var events = await _calendarApi!.events.list('primary');
        print("Fetched events: ${events.items}");
        // Process the events here, such as displaying them in a list
      } catch (e) {
        print("Error fetching events: $e");
      }
    }
  }

  @override
  void dispose() {
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Calendar API")),
      body: Center(
        child: ElevatedButton(
          onPressed: fetchGoogleCalendarEvents,
          child: Text("Fetch Events"),
        ),
      ),
    );
  }
}
