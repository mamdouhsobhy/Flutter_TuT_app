
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tut_app/presentation/resources/languageManager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED = "PREFS_KEY_ONBOARDING_SCREEN_VIEWED";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";

class AppPreferences{
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async{
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if(language!=null && language.isNotEmpty){
      return language;
    }else{
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> setOnBoardingScreenViewed() async{
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreenViewed() async{
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED)?? false;
  }

  Future<void> setUserLoggedIn() async {
    print("🟢 Checking isUserLoggedIn(): CALLED");
     _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    bool isLoggedIn = _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
    print("🟢 Checking isUserLoggedIn(): $isLoggedIn");
    return isLoggedIn;
  }

}