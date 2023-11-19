import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String, dynamic> CITASNUTRICIONALES) async{
    return await baseRemota.collection("CITASNUTRICIONALES").add(CITASNUTRICIONALES);
  }

  static Future<List> mostrarTodos() async{
    List temp = [];
    var query = await baseRemota.collection("CITASNUTRICIONALES").get();

    query.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id':element.id
      });
      temp.add(dato);
    });
    return temp;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("CITASNUTRICIONALES").doc(id).delete();
  }
  static Future actualizar(Map<String, dynamic> CITASNUTRICIONALES) async{
    String id = CITASNUTRICIONALES['id'];
    CITASNUTRICIONALES.remove('id');
    return await baseRemota.collection("CITASNUTRICIONALES").doc(id).update(CITASNUTRICIONALES);
  }
}
