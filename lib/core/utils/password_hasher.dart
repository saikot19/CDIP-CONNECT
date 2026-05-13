import 'dart:convert';
import 'dart:math' as math;

class PasswordHasher {
  const PasswordHasher._();

  static final RegExp _md5Regex = RegExp(r'^[a-fA-F0-9]{32}$');

  static String forApi(String password) {
    final cleaned = password.trim();
    if (_md5Regex.hasMatch(cleaned)) return cleaned.toLowerCase();
    return md5(cleaned);
  }

  static String md5(String input) {
    final bytes = utf8.encode(input);
    final originalBitLength = bytes.length * 8;
    final message = <int>[...bytes, 0x80];

    while (message.length % 64 != 56) {
      message.add(0);
    }

    var bitLength = originalBitLength;
    for (var i = 0; i < 8; i++) {
      message.add(bitLength & 0xff);
      bitLength = bitLength >> 8;
    }

    var a0 = 0x67452301;
    var b0 = 0xefcdab89;
    var c0 = 0x98badcfe;
    var d0 = 0x10325476;

    final s = <int>[
      7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
      5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
      4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
      6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21,
    ];

    final k = List<int>.generate(
      64,
      (i) => (math.sin(i + 1).abs() * 4294967296).floor() & 0xffffffff,
    );

    for (var offset = 0; offset < message.length; offset += 64) {
      final m = List<int>.generate(16, (i) {
        final j = offset + i * 4;
        return message[j] |
            (message[j + 1] << 8) |
            (message[j + 2] << 16) |
            (message[j + 3] << 24);
      });

      var a = a0;
      var b = b0;
      var c = c0;
      var d = d0;

      for (var i = 0; i < 64; i++) {
        int f;
        int g;

        if (i < 16) {
          f = (b & c) | ((~b) & d);
          g = i;
        } else if (i < 32) {
          f = (d & b) | ((~d) & c);
          g = (5 * i + 1) % 16;
        } else if (i < 48) {
          f = b ^ c ^ d;
          g = (3 * i + 5) % 16;
        } else {
          f = c ^ (b | (~d));
          g = (7 * i) % 16;
        }

        f = (f + a + k[i] + m[g]) & 0xffffffff;
        a = d;
        d = c;
        c = b;
        b = (b + _leftRotate(f, s[i])) & 0xffffffff;
      }

      a0 = (a0 + a) & 0xffffffff;
      b0 = (b0 + b) & 0xffffffff;
      c0 = (c0 + c) & 0xffffffff;
      d0 = (d0 + d) & 0xffffffff;
    }

    return [_wordToHex(a0), _wordToHex(b0), _wordToHex(c0), _wordToHex(d0)]
        .join();
  }

  static int _leftRotate(int value, int shift) {
    return ((value << shift) | (value >> (32 - shift))) & 0xffffffff;
  }

  static String _wordToHex(int value) {
    final buffer = StringBuffer();
    for (var i = 0; i < 4; i++) {
      final byte = (value >> (8 * i)) & 0xff;
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
