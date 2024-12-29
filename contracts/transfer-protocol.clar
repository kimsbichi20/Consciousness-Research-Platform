;; Consciousness Transfer Protocol Contract

(define-map transfer-protocols
  { protocol-id: uint }
  {
    creator: principal,
    description: (string-utf8 1000),
    status: (string-ascii 20),
    approval-count: uint
  }
)

(define-data-var last-protocol-id uint u0)

(define-public (create-protocol (description (string-utf8 1000)))
  (let
    (
      (new-id (+ (var-get last-protocol-id) u1))
    )
    (map-set transfer-protocols
      { protocol-id: new-id }
      {
        creator: tx-sender,
        description: description,
        status: "proposed",
        approval-count: u0
      }
    )
    (var-set last-protocol-id new-id)
    (ok new-id)
  )
)

(define-public (approve-protocol (protocol-id uint))
  (let
    (
      (protocol (unwrap! (map-get? transfer-protocols { protocol-id: protocol-id }) (err u404)))
    )
    (ok (map-set transfer-protocols
      { protocol-id: protocol-id }
      (merge protocol { approval-count: (+ (get approval-count protocol) u1) })
    ))
  )
)

(define-public (update-protocol-status (protocol-id uint) (new-status (string-ascii 20)))
  (let
    (
      (protocol (unwrap! (map-get? transfer-protocols { protocol-id: protocol-id }) (err u404)))
    )
    (asserts! (is-eq (get creator protocol) tx-sender) (err u403))
    (ok (map-set transfer-protocols
      { protocol-id: protocol-id }
      (merge protocol { status: new-status })
    ))
  )
)

(define-read-only (get-protocol (protocol-id uint))
  (ok (map-get? transfer-protocols { protocol-id: protocol-id }))
)

