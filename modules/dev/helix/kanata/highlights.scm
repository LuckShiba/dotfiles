;; from axlefublr
["(" ")"] @punctuation.bracket

(identifier) @variable
(number) @constant.numeric

(defcfg
  (
    (identifier) @_boolean
    (#any-of? @_boolean "false" "true" "yes" "no")
  ) @constant.builtin.boolean
)

(variable_reference) @constant
(alias_reference) @function.macro

(list
  head: [(identifier) (alias_reference)] @function
  (#any-of? @function
    "arbitrary-code" "caps-word" "caps-word-custom" "caps-word-custom-toggle" "caps-word-toggle" "clipboard-cmd-set" "clipboard-restore" "clipboard-save" "clipboard-save-cmd-set" "clipboard-save-swap" "clipboard-set" "cmd" "cmd-log" "cmd-output-keys" "concat" "defalias" "defaliasenvcond" "defcfg" "defchords" "defchordsv2" "deflayer" "deflayermap" "deflocalkeys-linux" "deflocalkeys-macos" "deflocalkeys-win" "deflocalkeys-winiov2" "deflocalkeys-wintercept" "defoverrides" "defseq" "defsrc" "deftemplate" "defvar" "defvirtualkeys" "defzippy" "dynamic-macro-play" "dynamic-macro-record" "dynamic-macro-record-stop" "dynamic-macro-record-stop-truncate" "environment" "fork" "hold-for-duration" "if-equal" "if-in-list" "if-not-equal" "if-not-in-list" "include" "layer-switch" "layer-toggle" "layer-while-held" "macro" "macro-cancel-on-press" "macro-release-cancel" "macro-release-cancel-and-cancel-on-press" "macro-repeat" "macro-repeat-" "macro-repeat-cancel-on-press" "macro-repeat-release-cancel" "macro-repeat-release-cancel-and-cancel-on-press" "movemouse-accel-down" "movemouse-accel-left" "movemouse-accel-right" "movemouse-accel-up" "movemouse-down" "movemouse-left" "movemouse-right" "movemouse-speed" "movemouse-up" "multi" "mwheel-down" "mwheel-left" "mwheel-right" "mwheel-up" "on-idle" "on-physical-idle" "on-press" "on-release" "one-shot" "one-shot-pause-processing" "one-shot-press" "one-shot-press-pcancel" "one-shot-release" "one-shot-release-pcancel" "platform" "push-msg" "release-key" "release-layer" "sequence" "sequence-noerase" "setmouse" "t!" "tap-dance" "tap-dance-eager" "tap-hold" "tap-hold-except-keys" "tap-hold-press" "tap-hold-press-timeout" "tap-hold-release" "tap-hold-release-keys" "tap-hold-release-timeout" "template-expand" "unicode" "unmod" "unshift"
    "layer↑" "on↑" "on↓" ;; aliases I decided to recognize
    "switch" "or" "and" "not" "key-history" "key-timing" "input" "input-history" "layer" "base-layer"
  )
)

(
  [
    "defcfg"
    "defalias"
    "defvar"
    "defsrc"
    "deflayer"
    "deflayermap"
    "include"
  ] @function
)

(defvar
  name: (identifier) @function.macro
)

(defalias
  name: (identifier) @function.macro
)

(list
  head: (identifier) @function
  (#any-of? @function "on↓" "on↑")
  .
  (identifier)
  .
  [(identifier) (alias_reference)] @function.macro
)

(list
  head: (identifier) @operator
  (#eq? @operator "not")
)

(list
  head: (identifier) @keyword.control.conditional
  (#eq? @keyword.control.conditional "switch")
  (identifier) @keyword.control.repeat
  (#any-of? @keyword.control.repeat "fallthrough" "break")
)

(list
  head: (identifier) @operator
  (#eq? @operator "layer")
  (identifier) @type
)

(list
  head: (identifier) @function
  (#any-of? @function "layer-while-held" "layer-switch" "layer-toggle" "release-layer" "layer↑")
  .
  (identifier) @type
)

(deflayermap
  name: (identifier) @type
)

(deflayer
  name: (identifier) @type
)

(list
  .
  (identifier) @function
  (#any-of? @function "deftemplate" "template-expand" "t!")
  .
  (identifier) @type
)

[
  (string)
  (raw_string)
] @string

(
  (identifier) @operator.special
  (#any-of? @operator.special "XX" "_" "__" "___")
)

[
  (line_comment)
  (block_comment)
] @comment
