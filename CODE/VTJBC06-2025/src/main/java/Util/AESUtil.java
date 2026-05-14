package Util;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;
public class AESUtil {
	 public static byte[] decrypt(byte[] encryptedData, String secretKey) throws Exception {

	        SecretKeySpec key = new SecretKeySpec(secretKey.getBytes(), "AES");
	        Cipher cipher = Cipher.getInstance("AES");
	        cipher.init(Cipher.DECRYPT_MODE, key);

	        return cipher.doFinal(encryptedData);
	    }
	

public static byte[] decryptBytes(byte[] data, String key) throws Exception {

    SecretKeySpec skey = new SecretKeySpec(
        key.getBytes(), "AES");

    Cipher cipher = Cipher.getInstance("AES");
    cipher.init(Cipher.DECRYPT_MODE, skey);

    return cipher.doFinal(data);
}
}
