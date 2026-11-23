(in-package #:autolith)

;; Keep the original function so reloading init.lisp does not stack wrappers.
(defvar *nic-usfq-original-headers* nil)
(defvar *nic-usfq-headers-wrapper* nil)

(defun nic-usfq-tested-headers-function-p (function configuration)
  "Check both the active and tracked definitions against the tested version."
  (handler-case
      (let* ((*package* (find-package '#:autolith))
             (*read-eval* nil)
             (expected
               '(defun openai-compatible--request-headers
                    (provider credentials conversation)
                  "Return authenticated headers for one Chat Completions request."
                  (declare (ignore conversation))
                  (openai-compatible--authenticated-headers
                   credentials
                   :accept "text/event-stream"
                   :content-type "application/json"
                   :custom (openai-compatible-provider-headers provider))))
             (tracked (self-tracked-definition-source configuration expected))
             (source (sb-introspect:find-definition-source function))
             (pathname (sb-introspect:definition-source-pathname source))
             (offset (sb-introspect:definition-source-character-offset source)))
        (and tracked pathname offset
             (equal (read-from-string tracked) expected)
             (with-open-file (stream pathname)
               (file-position stream offset)
               (equal (read stream nil nil) expected))))
    (error () nil)))

(defun nic-usfq-install-session-header ()
  "Install the USFQ session header only for the tested upstream function."
  (let* ((name 'openai-compatible--request-headers)
         (current (and (fboundp name) (symbol-function name)))
         (original (if (eq current *nic-usfq-headers-wrapper*)
                       *nic-usfq-original-headers*
                       current)))
    (cond
      ((not (nic-usfq-tested-headers-function-p original
                                                *user-init-configuration*))
       (when (and current (eq current *nic-usfq-headers-wrapper*))
         (setf (symbol-function name) original))
       (setf *nic-usfq-original-headers* nil
             *nic-usfq-headers-wrapper* nil)
       (warn "USFQ X-Session-Id disabled: Autolith's request-header function changed or its source is unavailable. Review autolith-usfq.lisp."))
      ((not (eq current *nic-usfq-headers-wrapper*))
       (let ((wrapper
               (lambda (provider credentials conversation)
                 (let ((headers (funcall original provider credentials
                                         conversation)))
                   (if (string= (openai-compatible-provider-display-name provider)
                                "usfq")
                       (acons "X-Session-Id" (conversation-identifier conversation)
                              (remove "X-Session-Id" headers
                                      :key #'car :test #'string-equal))
                       headers)))))
         (setf *nic-usfq-original-headers* original
               *nic-usfq-headers-wrapper* wrapper
               (symbol-function name) wrapper))))))

(nic-usfq-install-session-header)
