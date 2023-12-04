;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname basic-client) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH  400)
(define HEIGHT 800)
(define TEXT-SIZE  14)
(define TEXT-COLOR "BLACK")
(define TEXT-X 10)
(define TEXT-Y 10)
(define BLANK (square 0 "solid" "white"))
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define MTBUF "")
(define MTLOT (list))

(define BUFBOX
  (rectangle
   (- WIDTH 20)
   (* 2 TEXT-SIZE)
   "outline"
   "black"))


;                                                                              
;                                                                              
;   ;;;;;;;;             ;;                 ;;;;;;;;              ;;;          
;   ;;;;;;;;;            ;;                 ;;;;;;;;;            ;;;;          
;   ;;    ;;;            ;;                 ;;    ;;;            ;;            
;   ;;    ;;;   ;;;;;  ;;;;;;  ;;;;;        ;;    ;;;   ;;;;;; ;;;;;;  ;;;;;;  
;   ;;    ;;;  ;;;;;;; ;;;;;; ;;;;;;;       ;;    ;;;  ;;;;;;; ;;;;;;  ;;;;;;  
;   ;;    ;;;  ;;   ;;   ;;   ;;   ;;       ;;    ;;;  ;;   ;;;  ;;    ;;      
;   ;;    ;;;       ;;   ;;        ;;       ;;    ;;;  ;;    ;;  ;;    ;;;     
;   ;;    ;;;  ;;;;;;;   ;;   ;;;;;;;       ;;    ;;;  ;;;;;;;;  ;;    ;;;;;;; 
;   ;;    ;;;  ;;   ;;   ;;   ;;   ;;       ;;    ;;;  ;;        ;;        ;;; 
;   ;;    ;;; ;;;   ;;   ;;  ;;;   ;;       ;;    ;;;  ;;        ;;         ;; 
;   ;;;;;;;;   ;;;;;;;   ;;   ;;;;;;;       ;;;;;;;;   ;;;;;;;;  ;;    ;;;;;;; 
;   ;;;;;;;;   ;;;;;;;   ;;   ;;;;;;;       ;;;;;;;;    ;;;;;;;  ;;    ;;;;;;; 
;                                                                              
;                                                                              
;                                                                              
;                                                                              


;; Message is one of:
;;
;;  (list "twt" STRING)         Client to Server   a new twt
;;  (list "lot" ListOfString)   Server to Client   list of 20 recent twts

(define-struct cs (uname buf lot))
;; ClientState is (make-cs String String ListOfString)
;; interp. the username and the most recent list of twts received from the server
(define CS1 (make-cs "Luna" MTBUF (list "1")))
(define CS2 (make-cs "Ginny" MTBUF (list "3" "2" "1")))


;                                               
;                                               
;   ;;;;;;;;;                                   
;   ;;;;;;;;;                                   
;   ;;                                          
;   ;;        ;;   ;;; ;;;;;;;   ;;;;;  ;;;;;;  
;   ;;        ;;   ;;; ;;;;;;;  ;;;;;;; ;;;;;;  
;   ;;;;;;;;; ;;   ;;; ;;   ;;; ;;   ;; ;;      
;   ;;;;;;;;; ;;   ;;; ;;    ;;;;;      ;;;     
;   ;;        ;;   ;;; ;;    ;;;;;      ;;;;;;; 
;   ;;        ;;   ;;; ;;    ;;;;;          ;;; 
;   ;;        ;;   ;;; ;;    ;; ;;   ;;      ;; 
;   ;;        ;;;;;;;; ;;    ;; ;;;;;;; ;;;;;;; 
;   ;;         ;;;;;;; ;;    ;;  ;;;;;  ;;;;;;; 
;                                               
;                                               
;                                               


;; String -> Image
;; render the unsent buffer to screen
(define (render-buf buf)
  (overlay/align/offset
   "left"
   "center"
   (text buf TEXT-SIZE TEXT-COLOR)
   -20
   0
   BUFBOX))



(check-expect
 (render-cs (make-cs "Tim" MTBUF (list "2" "1")))
 (place-image/align (above/align "left"
                                 (render-buf MTBUF)
                                 (lot-to-image (list "2" "1")))
                    TEXT-X TEXT-Y
                    "left"
                    "top"
                    BACKGROUND))

;; -------------------------------------------------------------------
;; ClientState -> Image
;; place the rendering of client-lot at TEXT-X TEXT-Y
(define (render-cs cs)
  (place-image/align
   (above/align "left"
                (render-buf (cs-buf cs))
                (lot-to-image (cs-lot cs)))
   TEXT-X TEXT-Y
   "left" "top"
   BACKGROUND))

(check-expect (lot-to-image empty) BLANK)
(check-expect (lot-to-image (list "2" "1"))
              (above/align "left"
                           (txt-to-image "2")
                           (above/align "left"
                                        (txt-to-image "1")
                                        BLANK)))

;; ListOfString -> Image
;; render the twts one above the other
(define (lot-to-image lot)
  (local ((define (add-above a-txt an-img)
            (above/align "left" (txt-to-image a-txt) an-img)))
    (foldr add-above BLANK lot)))

;; String -> Image
;; convert the string to an image of the appropriate size and color
(check-expect (txt-to-image "a") (text "a" TEXT-SIZE TEXT-COLOR))

;; String -> Image
(define (txt-to-image str)
  (text str TEXT-SIZE TEXT-COLOR))

;; -------------------------------------------------------------------

(check-expect (handle-msg (make-cs  "Tim" MTBUF (list "1")) (list "lot" (list "2" "1")))
              (make-cs "Tim" MTBUF (list "2" "1")))


;; ClientState Message -> ClientState
;; Update client state to new list of twts
(define (handle-msg cs msg)
  (cond [(string=? "lot" (first msg))
         (make-cs (cs-uname cs) (cs-buf cs) (second msg))]))


;; -------------------------------------------------------------------

;; ClientState KeyEvent -> ClientState or Package
;; when space is pressed, send a twt of the next natural number
;; otherwise cs doesn't change
;; NOTE, we wait for message back from server to update cs-lot

(check-expect (handle-key (make-cs "Tim" MTBUF (list "21")) "left")   ;nothing happens
              (make-cs "Tim" "left" (list "21")))
(check-expect (handle-key (make-cs "Tim" MTBUF (list "21")) "a")
              (make-cs "Tim" "a" (list "21")))
(check-expect (handle-key (make-cs "Tim" MTBUF (list "21")) "5")
              (make-cs "Tim" "5" (list "21")))

;; String String -> String
(define (append-to-buf buf key)
  (string-append buf key))

;; String String -> String
(define (name+msg uname msg)
  (string-append uname ": " msg))


;; ClientState Key -> CLientState
(define (handle-key cs key)
  (cond [(key=? key "\r")
         (make-package
          (make-cs (cs-uname cs)
                   MTBUF
                   (cons
                    (name+msg
                     (cs-uname cs)
                     (append-to-buf (cs-buf cs) key))
                    (cs-lot cs)))
          (list "twt" (name+msg
                       (cs-uname cs)
                       (append-to-buf (cs-buf cs) key))))]
        [else (make-cs (cs-uname cs)
                       (append-to-buf (cs-buf cs) key)
                       (cs-lot cs))]))


;; -------------------------------------------------------------------
;; -------------------------------------------------------------------


;; String String -> ClientState
;; The main function for the simple counter client.
;; Starts the client, connecting it to server at server-name.
;; Start the client with something like:
;;   (client "Tom" "LOCALHOST")      if server is running on same machine
;;   (client "Tim" "dog.cat.shu.edu") if running on another machine
;;
;;   (launch-many-worlds (client "Tom" "LOCALHOST")  to get more than one client
;;                       (client "Tim" "LOCALHOST")) running on local machine
;;
(define (client uname server-name)
  (big-bang (make-cs uname MTBUF MTLOT)
    (register   server-name)
    (to-draw    render-cs)
    (on-receive handle-msg)
    (on-key     handle-key)))

#;(launch-many-worlds (client "J1" "LOCALHOST")
                    (client "J2" "LOCALHOST"))

(client "Jason" "10.22.164.175")
"http://hemann.pl"