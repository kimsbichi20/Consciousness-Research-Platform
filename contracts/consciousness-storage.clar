;; Consciousness Storage Contract

(define-data-var last-consciousness-id uint u0)

(define-map consciousness-data
  { consciousness-id: uint }
  {
    owner: principal,
    data-hash: (buff 32),
    timestamp: uint,
    status: (string-ascii 20)
  }
)

(define-public (store-consciousness (data-hash (buff 32)))
  (let
    (
      (new-id (+ (var-get last-consciousness-id) u1))
    )
    (map-set consciousness-data
      { consciousness-id: new-id }
      {
        owner: tx-sender,
        data-hash: data-hash,
        timestamp: block-height,
        status: "stored"
      }
    )
    (var-set last-consciousness-id new-id)
    (ok new-id)
  )
)

(define-public (update-consciousness-status (consciousness-id uint) (new-status (string-ascii 20)))
  (let
    (
      (consciousness (unwrap! (map-get? consciousness-data { consciousness-id: consciousness-id }) (err u404)))
    )
    (asserts! (is-eq (get owner consciousness) tx-sender) (err u403))
    (ok (map-set consciousness-data
      { consciousness-id: consciousness-id }
      (merge consciousness { status: new-status })
    ))
  )
)

(define-read-only (get-consciousness (consciousness-id uint))
  (ok (map-get? consciousness-data { consciousness-id: consciousness-id }))
)

