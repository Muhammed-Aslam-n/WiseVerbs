class RegisterUserModel {
  final String name;
  final String occupation;
  final String inspiration;
  final String favQuote;
  final String aboutYou;
  String profilePicture;

  RegisterUserModel({
    required this.name,
    required this.occupation,
    required this.inspiration,
    required this.favQuote,
    required this.aboutYou,
    required this.profilePicture,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) =>
      RegisterUserModel(
        name: json['name'],
        occupation: json['occupation'],
        inspiration: json['inspiration'],
        favQuote: json['favQuote'],
        aboutYou: json['aboutYou'],
        profilePicture: json['profilePicture'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'occupation': occupation,
        'inspiration': inspiration,
        'favQuote': favQuote,
        'aboutYou': aboutYou,
        'profilePicture': profilePicture,
      };
}
