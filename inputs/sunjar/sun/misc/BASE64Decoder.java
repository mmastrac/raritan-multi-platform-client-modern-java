package sun.misc;

public class BASE64Decoder {
  public byte[] decodeBuffer(String s) {
    return java.util.Base64.getDecoder().decode(s);
  }
}
