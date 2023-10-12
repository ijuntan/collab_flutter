String formatDate(String date) {
  final DateTime parsedDate = DateTime.parse(date);
  if (DateTime.now().difference(parsedDate).inDays > 0) {
    return '${DateTime.now().difference(parsedDate).inDays}d';
  }
  if (DateTime.now().difference(parsedDate).inHours > 0) {
    return '${DateTime.now().difference(parsedDate).inHours}h';
  }
  if (DateTime.now().difference(parsedDate).inMinutes > 0) {
    return '${DateTime.now().difference(parsedDate).inMinutes}m';
  }

  return '${parsedDate.difference(DateTime.now()).inSeconds}s';
}
