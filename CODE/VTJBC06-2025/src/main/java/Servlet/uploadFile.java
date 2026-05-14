package Servlet;

import java.io.*;
import java.security.*;
import java.sql.*;
import java.util.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import Database.DBConnection;

@WebServlet("/uploadFile")
@MultipartConfig
public class uploadFile extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("device_email") == null) {
            response.sendRedirect("device_login.jsp");
            return;
        }

        String email = session.getAttribute("device_email").toString();
        String fileName = request.getParameter("file_name");
        String controllerContentInput = request.getParameter("controller_content");

        try {

            // --- Read uploaded file ---
            Part filePart = request.getPart("uploadFile");
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            try (InputStream is = filePart.getInputStream()) {
                byte[] temp = new byte[4096];
                int read;
                while ((read = is.read(temp)) != -1) {
                    buffer.write(temp, 0, read);
                }
            }
            byte[] fileBytes = buffer.toByteArray();

            // --- Split controller content into two halves for DB storage ---
            int mid = controllerContentInput.length() / 2;
            String controllerContent = controllerContentInput.substring(0, mid);   // first half
            String judgeContent = controllerContentInput.substring(mid);            // second half

            // --- Divide content into 3 blocks for fog nodes hashing (unchanged) ---
            String[] fogBlocks = divideIntoBlocks(controllerContentInput, 3);

            // --- Generate AES key ---
            SecretKey aesKey = generateAESKey();

            // --- Encrypt only the file ---
            byte[] encFile = aesEncrypt(fileBytes, aesKey);

            try (Connection con = DBConnection.connect()) {

                // --- Generate RSA key pair ---
                KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
                kpg.initialize(2048);
                KeyPair kp = kpg.generateKeyPair();

                // --- Encrypt AES key with RSA public key ---
                Cipher rsa = Cipher.getInstance("RSA");
                rsa.init(Cipher.ENCRYPT_MODE, kp.getPublic());
                String encAesKey = Base64.getEncoder().encodeToString(rsa.doFinal(aesKey.getEncoded()));

                // --- Store private key ---
                String privateKey = Base64.getEncoder().encodeToString(kp.getPrivate().getEncoded());

                // --- Insert file + controller/judge halves into DB ---
                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO uploaded_files " +
                                "(file_name, device_email, file_data, controller_content, judge_content, public_key, private_key) " +
                                "VALUES (?,?,?,?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS
                );

                ps.setString(1, fileName);
                ps.setString(2, email);
                ps.setBytes(3, encFile);
                ps.setString(4, controllerContent); // first half
                ps.setString(5, judgeContent);      // second half
                ps.setString(6, encAesKey);         // RSA-encrypted AES key
                ps.setString(7, privateKey);

                int result = ps.executeUpdate();

                if (result > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    rs.next();
                    int fid = rs.getInt(1);

                    // --- Generate IDs ---
                    String transactionId = "TX_" + fid + "_" + System.currentTimeMillis();
                    String smartContractId = "SC_" + fid + "_" + UUID.randomUUID().toString().substring(0, 8);

                    // --- Store IDs in DB ---
                    PreparedStatement ups = con.prepareStatement(
                        "UPDATE uploaded_files SET transaction_id=?, smart_contract_id=? WHERE fid=?"
                    );
                    ups.setString(1, transactionId);
                    ups.setString(2, smartContractId);
                    ups.setInt(3, fid);
                    ups.executeUpdate();


                    // --- Insert blockchain logs for fog nodes using divided blocks ---
                    List<String> fogNodes = getFogNodes(con);
                    for (int i = 0; i < fogNodes.size(); i++) {
                        PreparedStatement fps = con.prepareStatement(
                                "INSERT INTO blockchain_logs (fid, device_email, file_hash, fog_node) VALUES (?,?,?,?)"
                        );
                        fps.setInt(1, fid);
                        fps.setString(2, email);
                        fps.setString(3, sha256(fogBlocks[i])); // distinct block hash
                        fps.setString(4, fogNodes.get(i));
                        fps.executeUpdate();
                    }
                    // ✅ OPTIONAL BUT RECOMMENDED (backup fid)
                    session.setAttribute("last_uploaded_fid", fid);
                    session.setAttribute("msg", "File uploaded & encrypted successfully");
                    response.sendRedirect("file_transaction_graph.jsp?fid=" + fid);

                } else {
                    session.setAttribute("msg", "File upload failed");
                    response.sendRedirect("upload_file.jsp");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "File upload failed");
            response.sendRedirect("upload_file.jsp");
        }
    }

    // --- AES Encryption ---
    private byte[] aesEncrypt(byte[] data, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);

        byte[] encrypted = cipher.doFinal(data);

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        outputStream.write(iv); // prepend IV
        outputStream.write(encrypted);
        return outputStream.toByteArray();
    }

    // --- AES Key Generation ---
    private SecretKey generateAESKey() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(128); // AES-128
        return kg.generateKey();
    }

    // --- Divide content into n roughly equal blocks for fog node hashing ---
    private String[] divideIntoBlocks(String content, int n) {
        String[] blocks = new String[n];
        int blockSize = (int) Math.ceil((double) content.length() / n);
        for (int i = 0; i < n; i++) {
            int start = i * blockSize;
            int end = Math.min(start + blockSize, content.length());
            blocks[i] = content.substring(start, end);
        }
        return blocks;
    }

    private List<String> getFogNodes(Connection con) throws Exception {
        List<String> list = new ArrayList<>();
        ResultSet rs = con.prepareStatement(
                "SELECT fog_name FROM fog_nodes WHERE status='ACTIVE' LIMIT 3"
        ).executeQuery();
        while (rs.next()) list.add(rs.getString("fog_name"));
        return list;
    }

    private String sha256(String data) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        return Base64.getEncoder().encodeToString(md.digest(data.getBytes("UTF-8")));
    }
}
