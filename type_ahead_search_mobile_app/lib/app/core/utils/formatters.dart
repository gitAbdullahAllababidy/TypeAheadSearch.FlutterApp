import 'package:intl/intl.dart';

class Formatters {
  Formatters._(); 
  
  // Date formatters
  static final DateFormat eventListDateFormat = DateFormat('E, d MMM yyyy hh:mm a');
  static final DateFormat eventDetailDateFormat = DateFormat('E, d MMM yyyy hh:mm a');
  
  // Venue formatter
  static String formatVenue(String city, String state) {
    return '$city, $state';
  }
  
  /// Format date for event list items
  static String formatEventDate(DateTime dateTime) {
    return eventListDateFormat.format(dateTime);
  }
  
  /// Format date for event details
  static String formatEventDetailDate(DateTime dateTime) {
    return eventDetailDateFormat.format(dateTime);
  }
}
