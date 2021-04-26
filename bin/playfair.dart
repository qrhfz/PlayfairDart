import 'dart:io';

import 'package:args/args.dart';

ArgResults argResults;
const lineNumber = 'line-number';
void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag('encrypt', negatable: false, abbr: 'e')
    ..addFlag('decrypt', negatable: false, abbr: 'd');

  try {
    argResults = parser.parse(arguments);

    final text = argResults.rest[0];
    final keyString = argResults.rest[1];

    if (argResults['encrypt']) {
      var cipherText = encrypt(text, keyString);
      print('Cipher Text = ' + cipherText);
    } else if (argResults['decrypt']) {
      var plainText = decrypt(text, keyString);
      print('Plain Text hasil dekripsi = ' + plainText);
    }
  } on FormatException catch (e) {
    print(e.message);
  } on Exception catch (e) {
    print(e);
  }
  // print(argResults['encrypt']);
  // var keyString = 'monarchy';
  // var plainText = 'instrument';

  //membuat matrix berdasarkan string key
}

//mengisi matrix kosong sesuai dengan string key
List generateMatrix(String keyString) {
  var matrix = generateEmptyMatrix(5, 2);
  var newKeyCharList = processKey(keyString);
  for (var i = 0; i < 5; i++) {
    for (var j = 0; j < 5; j++) {
      matrix[i][j] = newKeyCharList[i * 5 + j];
    }
  }
  return matrix;
}

//membuat matrix kosong dengan dimensi dan ukuran tertentu
List generateEmptyMatrix(int size, int d) {
  if (d > 1) {
    return List.generate(size, (i) => generateEmptyMatrix(size, d - 1),
        growable: false);
  } else {
    return List.generate(size, (i) => null, growable: false);
  }
}

String encrypt(String plainText, String keyString) {
  var matrix = generateMatrix(keyString);
  print('Matrix kunci');
  printMatrix(matrix);
  var plainTextChunks = createTextChunks(plainText);

  var cipherText = '';
  plainTextChunks.forEach((element) {
    var a = searchChar(matrix, element[0]);
    var b = searchChar(matrix, element[1]);

    if (a.kolom == b.kolom) {
      cipherText = cipherText +
          matrix[(a.baris < 4) ? a.baris + 1 : 0][a.kolom] +
          matrix[(b.baris < 4) ? b.baris + 1 : 0][a.kolom];
    } else if (a.baris == b.baris) {
      cipherText = cipherText +
          matrix[a.baris][(a.kolom < 4) ? a.kolom + 1 : 0] +
          matrix[a.baris][(b.kolom < 4) ? b.kolom + 1 : 0];
    } else {
      cipherText =
          cipherText + matrix[a.baris][b.kolom] + matrix[b.baris][a.kolom];
    }
  });

  return cipherText;
}

String decrypt(String cipherText, String keyString) {
  var matrix = generateMatrix(keyString);
  print('Matrix kunci');
  printMatrix(matrix);
  var cipherTextChunks = createTextChunks(cipherText);

  var plainText = '';
  cipherTextChunks.forEach((element) {
    var a = searchChar(matrix, element[0]);
    var b = searchChar(matrix, element[1]);

    if (a.kolom == b.kolom) {
      plainText = plainText +
          matrix[(a.baris > 0) ? a.baris - 1 : 4][a.kolom] +
          matrix[(b.baris > 0) ? b.baris - 1 : 4][a.kolom];
    } else if (a.baris == b.baris) {
      plainText = plainText +
          matrix[a.baris][(a.kolom > 0) ? a.kolom - 1 : 4] +
          matrix[a.baris][(b.kolom > 0) ? b.kolom - 1 : 4];
    } else {
      plainText =
          plainText + matrix[a.baris][b.kolom] + matrix[b.baris][a.kolom];
    }
  });
  return plainText;
}

//mencari lokasi suatu karakter di dalam sebuah matrix (baris, kolom)
Lokasi searchChar(List matrix, String a) {
  for (var i = 0; i < matrix.length; i++) {
    for (var j = 0; j < matrix.length; j++) {
      if (matrix[i][j] == a) return Lokasi(i, j);
    }
  }
  return Lokasi(-1, -1);
}

class Lokasi {
  final int baris;
  final int kolom;
  Lokasi(
    this.baris,
    this.kolom,
  );
}

//membuat string menjadi pasangan 2 karakter dengan tipe data list (array)
List createTextChunks(String string) {
  var textChunks = [];
  string = string.toUpperCase().replaceAll(RegExp(r"\s+\b|\b\s|J"), '');
  if (string.length % 2 != 0) string = string + 'Z';
  for (var i = 0; i < string.length; i += 2) {
    var charCouple = string.substring(i, i + 2);
    textChunks.add([charCouple[0], charCouple[1]]);
  }
  print('Pasangan Huruf : ' + textChunks.toString());
  return textChunks;
}

//memproses string key menjadi sebuah list karakter unik tanpa J
List processKey(String keyString) {
  var newKeyCharList = [];
  List alphabetList = 'ABCDEFGHIKLMNOPQRSTUVWXYZ'.split('');
  List keyCharList = keyString.toUpperCase().split('');

  keyCharList.forEach((element) {
    if (alphabetList.contains(element)) {
      alphabetList.remove(element);
      newKeyCharList.add(element);
    }
  });
  newKeyCharList.addAll(alphabetList);
  return newKeyCharList;
}

void printMatrix(dynamic matrix) {
  if (matrix != null) {
    if (matrix is String) {
      return;
    }
    matrix.forEach((element) {
      if (element is String) {
        stdout.write(element + ' ');
      }

      printMatrix(element);
    });
    print('');
  }
}
