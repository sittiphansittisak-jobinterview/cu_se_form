bool isStringEmpty(value) {
  if (value is! String) return true;
  return value.trim().isEmpty;
}
