/usr/local/opt/openjdk\@11/bin/javac --patch-module java.base=. sun/misc/BASE64Decoder.java
/usr/local/opt/openjdk\@11/bin/javac --patch-module java.base=. sun/misc/BASE64Encoder.java
/usr/local/opt/openjdk\@11/bin/jar --create --no-manifest --file sunbase64.jar sun/misc/BASE64Decoder.class sun/misc/BASE64Encoder.class
