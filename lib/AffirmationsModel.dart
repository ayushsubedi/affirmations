class AffirmationsModel{
  final String affirmation;

  AffirmationsModel({this.affirmation});

  factory AffirmationsModel.fromJson(final json){
    return AffirmationsModel(
      affirmation : json["affirmation"]
    );
  }
}