;; Consciousness Token Contract

(define-fungible-token consciousness-token)

(define-data-var token-uri (string-utf8 256) u"")

(define-constant contract-owner tx-sender)

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ft-mint? consciousness-token amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (ft-transfer? consciousness-token amount sender recipient)
  )
)

(define-public (reward-advancement (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ft-mint? consciousness-token amount recipient)
  )
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance consciousness-token account))
)

(define-public (set-token-uri (new-uri (string-utf8 256)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ok (var-set token-uri new-uri))
  )
)

(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

