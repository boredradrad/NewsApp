extension StringValidators on String{
  bool get isValidEmail{
    return !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+ $').hasMatch(this);
}
}

extension DateTimeOperations on DateTime{
  String  get formatTimeAgo{
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}