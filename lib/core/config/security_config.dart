class SecurityConfig {
  // Map host -> allowed SHA-256 certificate (DER) fingerprints (base64 or hex)
  // Replace placeholders with real fingerprints per environment.
  static const Map<String, List<String>> allowedSha256Fingerprints = {
    'api.aidoctorsystem.com': [
      // 'BASE64_SHA256_FINGERPRINT_HERE',
    ],
    'staging-api.aidoctorsystem.com': [
      // 'BASE64_SHA256_FINGERPRINT_HERE',
    ],
    'localhost': [],
  };
}


