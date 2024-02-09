enum TefResponseType {
  inProgress(1),
  collectionOption(2),
  transaction(3),
  finish(4),
  done(5),
  unknown(-1);

  final int what;

  const TefResponseType(this.what);
}
