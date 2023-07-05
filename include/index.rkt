#lang racket

(require ffi/unsafe
         "oid.rkt"
         "strarray.rkt"
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_index
                  _git_index_conflict_iterator
                  _git_tree)
         "../private/base.rkt")

(provide (all-defined-out))

; Types

(define-cstruct _git_index_time
  ([seconds _int32]
   [nanoseconds _uint32]))

(define-cstruct _git_index_entry
  ([ctime _git_index_time]
   [mtime _git_index_time]
   [dev _uint32]
   [ino _uint32]
   [mode _uint32]
   [uid _uint32]
   [gid _uint32]
   [file_size _uint32]
   [id _git_oid]
   [flags _uint16]
   [flags_extended _uint16]
   [path _string]))
(define _index_entry _git_index_entry-pointer)
(define _index_entry/null _git_index_entry-pointer/null)

(define-enum _git_index_entry_flag_t
  [GIT_INDEX_ENTRY_EXTENDED #x4000]
  [GIT_INDEX_ENTRY_VALID #x8000])

(define-bitmask _git_index_entry_extended_flag_t
  [GIT_INDEX_ENTRY_INTENT_TO_ADD (arithmetic-shift 1 13)]
  [GIT_INDEX_ENTRY_SKIP_WORKTREE (arithmetic-shift 1 14)]
  [GIT_INDEX_ENTRY_EXTENDED_FLAGS (bitwise-ior GIT_INDEX_ENTRY_INTENT_TO_ADD
                                               GIT_INDEX_ENTRY_SKIP_WORKTREE)]
  [GIT_INDEX_ENTRY_UPTODATE (arithmetic-shift 1 2)])
#|
;; from the deprecated git_idxentry_extended_flag_t enum
`(GIT_IDXENTRY_INTENT_TO_ADD = #x2000
  GIT_IDXENTRY_SKIP_WORKTREE = #x4000
  GIT_IDXENTRY_EXTENDED2 = #x8000
  GIT_IDXENTRY_EXTENDED_FLAGS = #x6000
  GIT_IDXENTRY_UPDATE = #x0001
  GIT_IDXENTRY_REMOTE = #x0002
  GIT_IDXENTRY_UPTODATE = #x0004
  GIT_IDXENTRY_ADDED = #x0008
  GIT_IDXENTRY_HASHED = #x0010
  GIT_IDXENTRY_UNHASHED = #x0020
  GIT_IDXENTRY_WT_REMOVE = #x0040
  GIT_IDXENTRY_CONFLICTED = #x0080
  GIT_IDXENTRY_UNPACKED = #x0100
  GIT_IDXENTRY_NEW_SKIP_WORKTREE = #x0200)
|#

(define-enum _git_index_capability_t
  #:base _fixint
  [GIT_INDEX_CAPABILITY_IGNORE_CASE 1]
  [GIT_INDEX_CAPABILITY_NO_FILEMODE 2]
  [GIT_INDEX_CAPABILITY_NO_SYMLINKS 4]
  [GIT_INDEX_CAPABILITY_FROM_OWNER -1])

(define _git_index_matched_path_cb
  (_fun _string _string _bytes -> _int))

(define-bitmask _git_index_add_option_t
  [GIT_INDEX_ADD_DEFAULT 0]
  [GIT_INDEX_ADD_FORCE 1]
  [GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH 2]
  [GIT_INDEX_ADD_CHECK_PATHSPEC 4])

(define-enum _git_index_stage_t
  #:base _fixint
  [GIT_INDEX_STAGE_ANY -1]
  GIT_INDEX_STAGE_NORMAL
  GIT_INDEX_STAGE_ANCESTOR
  GIT_INDEX_STAGE_OURS
  GIT_INDEX_STAGE_THEIRS)

; Functions

(define-libgit2/check git_index_add
  (_fun _git_index _index_entry -> _int))

(define-libgit2/check git_index_add_all
  (_fun _git_index
        _git_strarray-pointer
        _git_index_add_option_t
        _git_index_matched_path_cb
        _bytes
        -> _int))

(define-libgit2/check git_index_add_bypath
  (_fun _git_index _string -> _int))

(define-libgit2/check git_index_add_from_buffer
  (_fun _git_index _index_entry _bytes _size -> _int))

(define-libgit2 git_index_caps
  (_fun _git_index -> _int))

(define-libgit2/check git_index_clear
  (_fun _git_index -> _int))

(define-libgit2/check git_index_conflict_add
  (_fun _git_index _index_entry _index_entry _index_entry -> _int))

(define-libgit2/check git_index_conflict_cleanup
  (_fun _git_index -> _int))

(define-libgit2 git_index_conflict_get
  (_fun [ancestor : (_ptr o _index_entry)]
        [our : (_ptr o _index_entry)]
        [their : (_ptr o _index_entry)]
        _git_index
        _string
        -> [v : (_git_error_code/check)]
        -> (values ancestor our their)))

(define-libgit2/dealloc git_index_conflict_iterator_free
  (_fun _git_index_conflict_iterator -> _void))

(define-libgit2/alloc git_index_conflict_iterator_new
  (_fun _git_index_conflict_iterator _git_index -> (_git_error_code/check))
  git_index_conflict_iterator_free)

(define-libgit2 git_index_conflict_next
  (_fun [ancestor : (_ptr o _index_entry)]
        [our : (_ptr o _index_entry)]
        [their : (_ptr o _index_entry)]
        _git_index_conflict_iterator
        -> [v : (_git_error_code/check)]
        -> (values ancestor our their)))

(define-libgit2/check git_index_conflict_remove
  (_fun _git_index _string -> _int))

(define-libgit2 git_index_entry_is_conflict
  (_fun _index_entry -> _bool))

(define-libgit2 git_index_entry_stage
  (_fun _index_entry -> _int))

(define-libgit2 git_index_entrycount
  (_fun _git_index -> _size))

(define-libgit2/alloc git_index_find
  (_fun _size _git_index _string -> _int))

(define-libgit2/alloc git_index_find_prefix
  (_fun _size _git_index _string -> _int))

(define-libgit2/dealloc git_index_free
  (_fun _git_index -> _void))

(define-libgit2 git_index_get_byindex
  (_fun _git_index _size -> _index_entry/null))

(define-libgit2 git_index_get_bypath
  (_fun _git_index _string _int -> _index_entry/null))

(define-libgit2 git_index_has_conflicts
  (_fun _git_index -> _bool))

(define-libgit2/alloc git_index_new
  (_fun _git_index -> _int)
  git_index_free)

(define-libgit2/alloc git_index_open
  (_fun _git_index _string -> _int)
  git_index_free)

(define-libgit2 git_index_owner
  (_fun _git_index -> _git_repository))

(define-libgit2 git_index_path
  (_fun _git_index -> _string))

(define-libgit2/check git_index_read
  (_fun _git_index _bool -> _int))

(define-libgit2/check git_index_read_tree
  (_fun _git_index _git_tree -> _int))

(define-libgit2/check git_index_remove
  (_fun _git_index _string _int -> _int))

(define-libgit2/check git_index_remove_all
  (_fun _git_index
        _git_strarray-pointer
        _git_index_matched_path_cb
        _bytes
        -> _int))

(define-libgit2/check git_index_remove_bypath
  (_fun _git_index _string -> _int))

(define-libgit2/check git_index_remove_directory
  (_fun _git_index _string _int -> _int))

(define-libgit2/check git_index_set_caps
  (_fun _git_index _int -> _int))

(define-libgit2 git_index_version
  (_fun _git_index -> _uint))

(define-libgit2/check git_index_set_version
  (_fun _git_index _uint -> _int))

(define-libgit2/check git_index_update_all
  (_fun _git_index
        _git_strarray-pointer
        _git_index_matched_path_cb
        _bytes
        -> _int))

(define-libgit2/check git_index_write
  (_fun _git_index -> _int))

(define-libgit2/check git_index_write_tree
  (_fun _git_oid-pointer _git_index -> _int))

(define-libgit2/check git_index_write_tree_to
  (_fun _git_oid-pointer _git_index _git_repository -> _int))