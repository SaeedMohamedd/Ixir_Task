import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

class GetData {
  int index = 0;
  List<String> ppg_data = List<String>();
  void read_data() async {
    ByteData data = await rootBundle.load("assets/ppg-data.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      //print(table); //sheet Name
      // print(excel.tables[table].maxCols);
      // print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        ppg_data.add(row.toString().replaceAll('[', '').replaceAll(']', ''));
      }
    }
  }
}
