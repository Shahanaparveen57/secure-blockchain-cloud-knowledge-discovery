package Servlet;

import java.io.*;
import java.security.*;
import java.security.spec.*;
import java.sql.*;
import java.util.Base64;
import javax.crypto.*;
import javax.crypto.spec.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import Database.DBConnection;

@WebServlet("/verifyKeys")
public class verifyKeys extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int shareId = Integer.parseInt(request.getParameter("share_id"));

        try (Connection con = DBConnection.connect()) {

            // ===== FETCH SHARED DATA =====
            PreparedStatement ps = con.prepareStatement(
                "SELECT sk.file_name, sk.private_key, uf.file_data, uf.public_key " +
                "FROM shared_keys sk " +
                "JOIN uploaded_files uf ON sk.fid = uf.fid " +
                "WHERE sk.share_id=?"
            );
            ps.setInt(1, shareId);

            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("client_verify_keys.jsp?msg=invalid");
                return;
            }

            String fileName = rs.getString("file_name");
            byte[] encryptedFile = rs.getBytes("file_data");
            String encAESKey = rs.getString("public_key");
            String privateKeyStr = rs.getString("private_key");

            // ===== LOAD PRIVATE KEY =====
            privateKeyStr = privateKeyStr
                    .replaceAll("-----BEGIN.*KEY-----", "")
                    .replaceAll("-----END.*KEY-----", "")
                    .replaceAll("\\s+", "");

            byte[] privBytes = Base64.getDecoder().decode(privateKeyStr);
            PrivateKey privateKey = KeyFactory.getInstance("RSA")
                    .generatePrivate(new PKCS8EncodedKeySpec(privBytes));

            // ===== RSA → AES =====
            Cipher rsa = Cipher.getInstance("RSA");
            rsa.init(Cipher.DECRYPT_MODE, privateKey);
            byte[] aesKeyBytes = rsa.doFinal(Base64.getDecoder().decode(encAESKey));
            SecretKey aesKey = new SecretKeySpec(aesKeyBytes, "AES");

            // ===== AES DECRYPT =====
            byte[] plainFile = aesDecrypt(encryptedFile, aesKey);

            // ===== FORCE DOC DOWNLOAD =====
            String downloadName = fileName.endsWith(".doc") ? fileName : fileName + ".doc";

            response.reset();
            response.setContentType("application/msword");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + downloadName + "\"");
            response.setContentLength(plainFile.length);

            OutputStream out = response.getOutputStream();
            out.write(plainFile);
            out.flush();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("client_verify_keys.jsp?msg=error");
        }
    }

    private byte[] aesDecrypt(byte[] encrypted, SecretKey key) throws Exception {

        byte[] iv = new byte[16];
        System.arraycopy(encrypted, 0, iv, 0, 16);

        byte[] cipherText = new byte[encrypted.length - 16];
        System.arraycopy(encrypted, 16, cipherText, 0, cipherText.length);

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, key, new IvParameterSpec(iv));
        return cipher.doFinal(cipherText);
    }
}
