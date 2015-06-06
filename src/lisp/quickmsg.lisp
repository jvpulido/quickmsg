(require :cffi)
(require :cl-json)
(require :iterate)
(defpackage :quickmsg
  (:nicknames :qm)
  (:use :common-lisp :cffi :cl-json :iterate)
  (:export publisher-new
           publisher-destroy
           publish
           subscriber-new
	   subscriber-get-messages
           subscriber-destroy
	   async-subscriber-new
	   async-subscriber-spin
	   async-subscriber-destroy
           client-new
           client-destroy
           call-srv
	   service-call-timeout
           service-new
           service-destroy
           service-spin
           get-msg-stamp
           get-msg-str
           ok
	   init
	   shutdown))
(in-package :quickmsg)

(setf json:*json-identifier-name-to-lisp* 'json:simplified-camel-case-to-lisp)

(cffi:define-foreign-library libqm
    (t (:default "libcquickmsg")))
(cffi:use-foreign-library libqm)

;; Publisher

(cffi:defcfun ("qm_publisher_new" publisher-new) :pointer
  (topic :string))

(cffi:defcfun ("qm_publisher_destroy" publisher-destroy) :void
  (self_p :pointer))

(cffi:defcfun ("qm_publish" publish) :void
  (self_p :pointer)
  (msg :string))

;; Subscriber
(cffi:defcfun ("qm_subscriber_new" subscriber-new) :pointer 
  (topic :string)
  (queue-size :int))

(cffi:defcfun ("qm_subscriber_get_messages" subscriber-get-messages) :pointer
  (self_p :pointer))

(cffi:defcfun ("qm_subscriber_destroy" subscriber-destroy) :void
  (self_p :pointer))

(cffi:defcfun ("qm_async_subscriber_new" async-subscriber-new) :pointer
  (topic :string)
  (handler :pointer)
  (args :pointer))

(cffi:defcfun ("qm_async_subscriber_spin" async-subscriber-spin) :void
  (self_p :pointer))

(cffi:defcfun ("qm_async_subscriber_destroy" async-subscriber-destroy) :void
  (self_p :pointer))

;; Client
(cffi:defcfun ("qm_client_new" client-new) :pointer
  (topic :string))

(cffi:defcfun ("qm_client_destroy" client-destroy) :void
  (self_p :pointer))

; define an error condition when the service call times out
(define-condition service-call-timeout (error)
  ((request :initarg :request :reader request)))

(defun call-srv (self-p request)
  "Call the service with the given request string"  
  (let ((resp-ptr (cffi:foreign-alloc :pointer)))
    (cffi:with-foreign-string (req-str request)      
      (let* ((ret (cffi:foreign-funcall "qm_call_srv" 
				       :pointer self-p
				       :pointer req-str
				       :pointer resp-ptr
				       :int))
	     (resp-str (if (= ret 0) (foreign-string-to-lisp (mem-ref resp-ptr :pointer)) "")))
	(if (= ret 0) 
	    (progn 	      
	      (cffi:foreign-free (mem-ref resp-ptr :pointer)) ; free the string and the pointer we alloc'd
	      (cffi:foreign-free resp-ptr)
	      resp-str) ; return the value
	    (error 'service-call-timeout :request request))))))

;; Server
(cffi:defcfun ("qm_service_new" service-new) :pointer
  (topic :string)
  (impl :pointer))

(cffi:defcfun ("qm_service_destroy" service-destroy) :void
  (self_p :pointer))

(cffi:defcfun ("qm_service_spin" service-spin) :void
  (self_p :pointer))

;; Message
(cffi:defcfun ("qm_get_message_stamp" get-msg-stamp) :double
  (self_p :pointer))

(cffi:defcfun ("qm_get_message_str" get-msg-str) :string
  (self_p :pointer))

;; Misc
(cffi:defcfun ("qm_ok" ok) :boolean )

(cffi:defcfun ("qm_init" init) :void 
  (node-name :string))

(cffi:defcfun ("qm_shutdown" shutdown) :void
  (reason :string))
