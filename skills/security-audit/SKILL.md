# Skill: Security Audit

## When to use this skill
Activate when reviewing code for security vulnerabilities, hardening an application, or doing a pre-deployment security check.

## OWASP Top 10 Checklist

### A01 — Broken Access Control
- [ ] All routes/endpoints require authentication where appropriate
- [ ] Authorization checks happen server-side, not just client-side
- [ ] Direct object references are validated (can user A access user B's data?)
- [ ] Admin endpoints are behind role checks
- [ ] CORS policy is restrictive, not `*`

### A02 — Cryptographic Failures
- [ ] Sensitive data encrypted at rest (PII, credentials, payment data)
- [ ] TLS enforced for all data in transit (no HTTP)
- [ ] Passwords hashed with bcrypt/argon2/scrypt (never MD5/SHA1)
- [ ] No secrets in environment variables shipped to the frontend
- [ ] Cryptographic keys are rotated and stored in a secrets manager

### A03 — Injection
- [ ] SQL queries use parameterised statements / ORM (never string concatenation)
- [ ] NoSQL queries sanitised
- [ ] Shell commands avoid user input (or shell=False equivalent)
- [ ] Template engines have autoescaping enabled
- [ ] XML parsers have entity expansion disabled (XXE)

### A04 — Insecure Design
- [ ] Threat model exists for sensitive flows (auth, payment, data export)
- [ ] Rate limiting on authentication endpoints
- [ ] Account lockout after failed attempts
- [ ] Sensitive operations require re-authentication

### A05 — Security Misconfiguration
- [ ] Debug mode disabled in production
- [ ] Default credentials changed
- [ ] Error messages don't leak stack traces to end users
- [ ] Unnecessary features/endpoints disabled
- [ ] Security headers set (CSP, HSTS, X-Frame-Options, etc.)

### A06 — Vulnerable Components
- [ ] Dependencies audited (`npm audit`, `pip-audit`, `bundle audit`)
- [ ] No packages with known critical CVEs
- [ ] Docker base images are up to date
- [ ] Pinned dependency versions in production

### A07 — Authentication Failures
- [ ] Session tokens have sufficient entropy
- [ ] Sessions invalidated on logout
- [ ] Password reset tokens are time-limited and single-use
- [ ] MFA available for sensitive accounts
- [ ] JWT secrets are strong and rotated

### A08 — Software Integrity Failures
- [ ] Subresource Integrity (SRI) on CDN assets
- [ ] CI/CD pipeline is not accessible to external contributors without review
- [ ] Signed releases / container images

### A09 — Logging Failures
- [ ] Auth successes and failures are logged
- [ ] Logs do NOT contain passwords, tokens, or PII
- [ ] Logs are shipped to a separate, tamper-evident store
- [ ] Alerting on anomalous patterns

### A10 — SSRF
- [ ] User-supplied URLs are validated against an allowlist
- [ ] Outbound requests from the server don't reach internal metadata endpoints
- [ ] Cloud metadata endpoints (169.254.169.254) blocked

## Secrets Detection
Before every commit, check for:
```bash
# Patterns to grep for
grep -rn "password\s*=\s*['\"]" .
grep -rn "api_key\s*=\s*['\"]" .
grep -rn "secret\s*=\s*['\"]" .
grep -rn "BEGIN.*PRIVATE KEY" .
```

Or use tools: `git-secrets`, `trufflehog`, `gitleaks`

## Security Finding Report Format

```
## Security Finding: <Title>

**Severity:** Critical / High / Medium / Low / Informational
**Category:** <OWASP category>
**Location:** <file:line>

### Description
<What is the vulnerability and why is it exploitable?>

### Proof of Concept
<Minimal example showing how it can be exploited>

### Impact
<What can an attacker do with this?>

### Remediation
<Specific fix with code example>

### References
<CVE, CWE, OWASP link>
```
