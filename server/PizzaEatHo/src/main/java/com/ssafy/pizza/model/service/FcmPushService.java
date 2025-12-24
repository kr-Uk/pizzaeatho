//package com.ssafy.pizza.model.service;
//
//import java.io.IOException;
//import java.io.InputStream;
//import java.net.URI;
//import java.net.http.HttpClient;
//import java.net.http.HttpRequest;
//import java.net.http.HttpResponse;
//import java.nio.charset.StandardCharsets;
//import java.util.LinkedHashMap;
//import java.util.List;
//import java.util.Map;
//
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.core.io.Resource;
//import org.springframework.core.io.ResourceLoader;
//import org.springframework.stereotype.Service;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.fasterxml.jackson.core.JsonGenerator;
//import com.google.auth.oauth2.AccessToken;
//import com.google.auth.oauth2.GoogleCredentials;
//import com.google.auth.oauth2.ServiceAccountCredentials;
//
//@Service
//public class FcmPushService {
//    private static final Logger log = LoggerFactory.getLogger(FcmPushService.class);
//    private static final String FCM_SCOPE = "https://www.googleapis.com/auth/firebase.messaging";
//
//    private final ObjectMapper objectMapper;
//    private final ResourceLoader resourceLoader;
//    private final HttpClient httpClient;
//    private final boolean enabled;
//    private final String apiUrl;
//    private final String credentialsPath;
//    private final String projectIdOverride;
//    private final String orderReadyTitle;
//    private final String orderReadyBody;
//
//    private volatile GoogleCredentials credentials;
//    private volatile String projectId;
//
//    public FcmPushService(
//            ObjectMapper objectMapper,
//            ResourceLoader resourceLoader,
//            @Value("${fcm.enabled:false}") boolean enabled,
//            @Value("${fcm.api-url:}") String apiUrl,
//            @Value("${fcm.credentials-path:}") String credentialsPath,
//            @Value("${fcm.project-id:}") String projectIdOverride,
//            @Value("${fcm.order-ready.title:주문 알림}") String orderReadyTitle,
//            @Value("${fcm.order-ready.body:주문하신 상품이 준비됐습니다. 매장으로 방문해주세요.}") String orderReadyBody) {
//        this.objectMapper = objectMapper;
//        this.resourceLoader = resourceLoader;
//        this.httpClient = HttpClient.newHttpClient();
//        this.enabled = enabled;
//        this.apiUrl = apiUrl;
//        this.credentialsPath = credentialsPath;
//        this.projectIdOverride = projectIdOverride;
//        this.orderReadyTitle = orderReadyTitle;
//        this.orderReadyBody = orderReadyBody;
//    }
//
//    public void sendOrderReadyPush(String token, Integer orderId) throws IOException, InterruptedException {
//        if (!enabled) {
//            log.debug("FCM push disabled. Skipping send.");
//            return;
//        }
//        if (token == null || token.isBlank()) {
//            log.debug("FCM token missing. Skipping send.");
//            return;
//        }
//        if (credentialsPath == null || credentialsPath.isBlank()) {
//            log.warn("FCM credentials path not set. Skipping send.");
//            return;
//        }
//
//        ensureCredentialsLoaded();
//
//        Map<String, Object> message = new LinkedHashMap<>();
//        message.put("token", token);
//        message.put("notification", Map.of(
//                "title", orderReadyTitle,
//                "body", orderReadyBody
//        ));
//        Map<String, String> data = new LinkedHashMap<>();
//        data.put("type", "order_ready");
//        if (orderId != null) {
//            data.put("orderId", orderId.toString());
//        }
//        message.put("data", data);
//
//        Map<String, Object> payload = new LinkedHashMap<>();
//        payload.put("message", message);
//
//        ObjectMapper mapper = objectMapper.copy();
//        mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
//        String body = mapper.writeValueAsString(payload);
//        String url = resolveApiUrl();
//
//        HttpRequest request = HttpRequest.newBuilder(URI.create(url))
//                .header("Authorization", "Bearer " + getAccessToken())
//                .header("Content-Type", "application/json; charset=UTF-8")
//                .POST(HttpRequest.BodyPublishers.ofString(body, StandardCharsets.UTF_8))
//                .build();
//
//        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
//        if (response.statusCode() >= 400) {
//            log.warn("FCM send failed: {} {}", response.statusCode(), response.body());
//        }
//    }
//
//    private synchronized void ensureCredentialsLoaded() throws IOException {
//        if (credentials != null) {
//            return;
//        }
//
//        Resource resource = resourceLoader.getResource(credentialsPath);
//        if (!resource.exists()) {
//            throw new IOException("FCM credentials not found at: " + credentialsPath);
//        }
//
//        try (InputStream inputStream = resource.getInputStream()) {
//            GoogleCredentials loaded = GoogleCredentials.fromStream(inputStream).createScoped(List.of(FCM_SCOPE));
//            this.credentials = loaded;
//            if (projectIdOverride != null && !projectIdOverride.isBlank()) {
//                this.projectId = projectIdOverride;
//            } else if (loaded instanceof ServiceAccountCredentials serviceAccount) {
//                this.projectId = serviceAccount.getProjectId();
//            }
//        }
//
//        if (projectId == null || projectId.isBlank()) {
//            throw new IOException("FCM project id not available from credentials.");
//        }
//    }
//
//    private String resolveApiUrl() {
//        if (apiUrl != null && !apiUrl.isBlank()) {
//            return apiUrl;
//        }
//        return "https://fcm.googleapis.com/v1/projects/" + projectId + "/messages:send";
//    }
//
//    private String getAccessToken() throws IOException {
//        if (credentials == null) {
//            throw new IOException("FCM credentials not initialized.");
//        }
//        credentials.refreshIfExpired();
//        AccessToken accessToken = credentials.getAccessToken();
//        if (accessToken == null) {
//            credentials.refresh();
//            accessToken = credentials.getAccessToken();
//        }
//        if (accessToken == null) {
//            throw new IOException("Unable to acquire FCM access token.");
//        }
//        return accessToken.getTokenValue();
//    }
//}
