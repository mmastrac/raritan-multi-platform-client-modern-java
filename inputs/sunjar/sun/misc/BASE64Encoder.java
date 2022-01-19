package sun.misc;

public class BASE64Encoder {
  public String encode(byte[] b) {
    return java.util.Base64.getEncoder().encodeToString(b);
  }
}
