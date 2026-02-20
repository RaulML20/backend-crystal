require "http/server"

module Security
    CSP = "default-src 'self'; " \
        "base-uri 'self'; " \
        "object-src 'none'; " \
        "frame-ancestors 'none'; " \
        "img-src 'self' data:; " \
        "script-src 'self'; " \
        "style-src 'self' 'unsafe-inline'; " \
        "upgrade-insecure-requests"

    def self.apply_security_headers(res : HTTP::Server::Response)
        res.headers["X-Content-Type-Options"] = "nosniff"
        res.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
        res.headers["X-Frame-Options"] = "DENY"
        res.headers["Permissions-Policy"] = "geolocation=(), microphone=(), camera=()"
        res.headers["Cross-Origin-Opener-Policy"] = "same-origin"
        res.headers["Cross-Origin-Resource-Policy"] = "same-origin"
        res.headers["Content-Security-Policy"] = CSP
        res.headers["X-DNS-Prefetch-Control"] = "off"
        # res.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    end
end