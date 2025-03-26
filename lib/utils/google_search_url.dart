import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async {
  Uri searchUri = Uri(
    scheme: 'https',
    host: 'www.google.com',
    path: '/search',
    queryParameters: {'q': url},
  );

  if (await canLaunchUrl(searchUri)) {
    await launchUrl(searchUri);
  } else {
    print('Could not launch $url');
  }
}

void launchLink(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    print('Could not launch $uri');
  }
}
