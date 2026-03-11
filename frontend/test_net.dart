import 'package:http/http.dart' as http;
void main() async {
  try {
    var uri = Uri.parse('https://tdztvfzcdozpqlotrofr.supabase.co/auth/v1/health');
    var response = await http.get(uri);
    print("Success: ${response.statusCode}");
  } catch (e) {
    print("Error: $e");
  }
}
