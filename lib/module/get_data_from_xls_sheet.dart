import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

class GetData {
  //declare list of strings to store data that we impoet from xlsx sheet

  List<String> ppg_data = List<String>();

  //read method that read xlsx sheet and store data in list
  void read_data() async {
    ByteData data = await rootBundle.load("assets/ppg-data.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      //print(table); //sheet Name
      // print(excel.tables[table].maxCols);
      // print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        //the output contain [] so we remove [] from the data and added to
        // the list
        ppg_data.add(row.toString().replaceAll('[', '').replaceAll(']', ''));
      }
    }
  }
}
