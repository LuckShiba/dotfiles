;; from axlefublr
(list
  head: (identifier) @_action
  (#eq? @_action "cmd")
  .
  (identifier) @_executable
  (#eq? @_executable "bash")
  .
  (identifier) @_flag
  (#eq? @_flag "-c")
  .
  [(string) (raw_string)] @injection.content
  (#set! injection.language "bash")
)

(list
  head: (identifier) @_action
  (#eq? @_action "cmd")
  .
  (identifier) @_executable
  (#eq? @_executable "fish")
  .
  (identifier) @_flag
  (#eq? @_flag "-c")
  .
  [(string) (raw_string)] @injection.content
  (#set! injection.language "fish")
)
