import "dart:convert";
import "package:http/http.dart" as http;

class AuthenticationController {
  Future<dynamic> login(String username, String password) async {
    var uri = Uri.parse("http://195.15.228.250/manager_app/login/");

    var response = await http.post(uri,
        body: json.encode({"username": username, "password": password}),
        headers: {
          'Content-type': "application/json",
        });

    if (response.statusCode == 200) {
      var user = jsonDecode(response.body);
      if (user["user"]['group'] != "Agent constat") {
        return {"refreshToken": null, "accessToken": null, "user": null};
      }
      String refreshToken = user['tokens']['refresh'];
      String accessToken = user['tokens']['access'];

      int id = user['id'];
      dynamic userInfo = user['user'];
      dynamic agentSecteur = user['agent_secteur'];
      dynamic trigramme = user['trigramme'];
      dynamic telephone = user['telephone'];
      dynamic secteurPrimaire = user['secteur_primaire'];
      dynamic secteurSecondaire = user['secteur_secondaire'];
      dynamic stats = user['stats'];
      var userData = {};
      userData['id'] = id;
      userData['user'] = userInfo;
      userData['agentSecteur'] = agentSecteur;
      userData['trigramme'] = trigramme;
      userData['telephone'] = telephone;
      userData['secteurPrimaire'] = secteurPrimaire;
      userData['secteurSecondaire'] = secteurSecondaire;
      userData['stats'] = stats;

      if (refreshToken.isNotEmpty && accessToken.isNotEmpty) {
        print("response.body");
        return {
          "refreshToken": refreshToken,
          "accessToken": accessToken,
          "user": userData
        };
      } else {
        print(response.body);
        return {"refreshToken": null, "accessToken": null, "user": null};
      }
    } else {
      print(response.body);
      return {"refreshToken": null, "accessToken": null, "user": null};
    }
  }

  Future<bool> seDeconnecter(String refreshToken, String accessToken) async {
    Uri logout = Uri(
        scheme: "http",
        host: "195.15.228.250",
        path: "/manager_app/logout/",
        query: "token=$refreshToken");
    try {
      var response = await http.get(logout, headers: {
        'Authorization': "Bearer $accessToken",
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
