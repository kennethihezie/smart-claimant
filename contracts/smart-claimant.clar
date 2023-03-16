
;; title: smart-claimant
;; version: 1.0.0
;; summary: The time-locked wallet we created in the previous 
;; section is delightfully simple. But imagine that after it is 
;; deployed, the beneficiary desires to split the balance over 
;; multiple distinct beneficiaries. Maybe it was deployed by an 
;; old relative years ago and the beneficiary now wants to share 
;; with the rest of the family. Whatever the reason, we obviously 
;; cannot simply go back and change or redeploy the time-locked wallet.
;; At some point it is going to unlock, after which the sole beneficiary
;; can claim the entire balance. The solution? We can create
;; a minimal ad hoc smart contract to act as the beneficiary!
;; It will call claim, and if successful, disburse the tokens
;; to a list of principals equally.

;; description: The point of this exercise is to show how smart
;; contracts can interact with each other and how one can augment
;; functionality or mitigate issues of older contracts.

;; traits
;;

;; token definitions
;; 

;; constants
;;

;; data vars
(define-data-var beneficiaries (list 4 principal) 
  (list 
  'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 
  'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG 
  'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC 
  'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND
  )
)


(define-data-var amount uint u0)

;; data maps
;;

;; public functions
(define-public (clam) 
  (begin 
     (try! (as-contract (contract-call? .time-locked-wallet claim)))
     (let 
        (
          ;; create a local variable  
          (total-balance (as-contract (stx-get-balance tx-sender)))
          ;; (share (/ total-balance  u4))
        ) 
            (var-set amount (/ total-balance u4))
            (map loop (var-get beneficiaries))
            (ok true)
        )

  )
)

;; read only functions
;;

;; private functions
(define-private (loop (address principal)) 
    (as-contract (stx-transfer? (var-get amount) tx-sender address))
)

