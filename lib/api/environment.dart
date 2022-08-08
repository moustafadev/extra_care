class Environment{
  static final String url = 'https://chromateck.com/laurus/api/v1/';
  static final String userSignUp = url +'signup';
  static final String userLogin = url + 'login';

  static final Map<String, String> requestHeader = {
    'Content-Type': 'application/json'
  };
  static final Map<String, String> requestHeaderMedia = {
    'Content-Type': 'MediaType.MULTIPART_FORM_DATA_VALUE'
  };
}