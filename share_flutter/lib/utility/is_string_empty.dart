bool isStringEmpty(value) {
  if (value is! String) return false;
  return value.trim().isEmpty;
}
