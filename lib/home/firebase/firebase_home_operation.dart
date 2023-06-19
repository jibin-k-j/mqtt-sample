import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_test/home/models/light_model.dart';
import 'package:mqtt_test/home/models/meter_info_model.dart';

class FirebaseHomeOperation {
  //GETTING ALL LIGHTS
  static Future<List<LightModel>> getAllLights({required String userId}) async {
    List<LightModel> lights = [];
    final ref = FirebaseFirestore.instance;
    try {
      await ref.collection('devices').doc(userId).collection('lights').get().then((value) {
        for (var light in value.docs) {
          lights.add(
            LightModel(
              name: light.get('name'),
              productId: light.get('productId'),
              id: light.get('id'),
            ),
          );
        }
      });
      lights.sort((a, b) => a.id.compareTo(b.id));
    } catch (e) {
      log('Error from getting all lights data $e');
    }
    return lights;
  }

  //GETTING ALL METERS
  static Future<List<MeterInfoModel>> getAllMeters({required String userId}) async {
    List<MeterInfoModel> meters = [];
    final ref = FirebaseFirestore.instance;
    try {
      await ref.collection('devices').doc(userId).collection('meters').get().then((value) {
        for (var meter in value.docs) {
          meters.add(MeterInfoModel(name: meter.get('name'), meterId: meter.get('meterId')));
        }
      });

      meters.sort((a, b) => a.meterId.compareTo(b.meterId));
    } catch (e) {
      log('Error from getting all meters data $e');
    }
    return meters;
  }

  //ADDING LIGHT INTO FB
  static Future<bool> addLight(LightModel light, String uid) async {
    bool status = true;
    final ref = FirebaseFirestore.instance;
    try {
      await ref.collection('devices').doc(uid).collection('lights').add({
        'id': light.id,
        'name': light.name,
        'productId': light.productId,
      });
    } catch (e) {
      log('Error from adding light $e');
      status = false;
    }
    return status;
  }

  //ADDING LIGHT INTO FB
  static Future<bool> addMeter(MeterInfoModel meter, String uid) async {
    bool status = true;
    final ref = FirebaseFirestore.instance;
    try {
      await ref.collection('devices').doc(uid).collection('meters').add({
        'name': meter.name,
        'meterId': meter.meterId,
      });
    } catch (e) {
      log('Error from adding meter $e');
      status = false;
    }
    return status;
  }
}
