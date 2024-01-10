RegExp emailRegExp = RegExp(
  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  caseSensitive: false,
  multiLine: false,
);

RegExp passwordRegExp = RegExp(
  r'^.{8,}$',
);