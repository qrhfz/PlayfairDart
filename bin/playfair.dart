void main() {
  var keyString = 'monarchy';
  var plainText = 'instrument';

  //membuat matrix berdasarkan string key
  var matrix = generateMatrix(keyString);
  print('Matrix kunci');
  print(matrix);

  var cipherText = encrypt(plainText, matrix);
  print('Cipher Text = ' + cipherText);
  var plainText2 = decrypt(cipherText, matrix);
  print('Plain Text hasil dekripsi = ' + plainText2);
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

String encrypt(String plainText, List matrix) {
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

String decrypt(String cipherText, List matrix) {
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
  print(textChunks);
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
