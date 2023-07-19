#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository)
         "../private/base.rkt")

(provide (all-defined-out))

; Types

(define-cpointer-type _git_revwalk)

(define-bitmask _git_sort_t
  #:contract git_sort/c
  [GIT_SORT_NONE = 0]
  [GIT_SORT_TOPOLOGICAL = 1]
  [GIT_SORT_TIME = 2]
  [GIT_SORT_REVERSE = 4])

(define _git_revwalk_hide_cb
  (_fun _git_oid-pointer _bytes -> _int))

; Functions

(define-libgit2/check git_revwalk_add_hide_cb
  (_fun _git_revwalk _git_revwalk_hide_cb _bytes -> _int))

(define-libgit2/dealloc git_revwalk_free
  (_fun _git_revwalk -> _void))

(define-libgit2/check git_revwalk_hide
  (_fun _git_revwalk _git_oid-pointer -> _int))

(define-libgit2/check git_revwalk_hide_glob
  (_fun _git_revwalk _string -> _int))

(define-libgit2/check git_revwalk_hide_head
  (_fun _git_revwalk -> _int))

(define-libgit2/check git_revwalk_hide_ref
  (_fun _git_revwalk _string -> _int))

(define-libgit2/alloc git_revwalk_new
  (_fun _git_revwalk _git_repository -> _int)
  git_revwalk_free)

(define-libgit2 git_revwalk_next
  (_fun [oid : (_ptr o _git_oid)]
        _git_revwalk
        -> [code : (_git_error_code/check #:handle '(GIT_ITEROVER))]
        -> (if (eq? code 'GIT_ITEROVER)
               #f
               oid)))

(define-libgit2/check git_revwalk_push
  (_fun _git_revwalk _git_oid-pointer -> _int))

(define-libgit2/check git_revwalk_push_glob
  (_fun _git_revwalk _string -> _int))

(define-libgit2/check git_revwalk_push_head
  (_fun _git_revwalk -> _int))

(define-libgit2/check git_revwalk_push_range
  (_fun _git_revwalk _string -> _int))

(define-libgit2/check git_revwalk_push_ref
  (_fun _git_revwalk _string -> _int))

(define-libgit2 git_revwalk_repository
  (_fun _git_revwalk -> _git_repository))

(define-libgit2 git_revwalk_reset
  (_fun _git_revwalk -> _void))

(define-libgit2 git_revwalk_simplify_first_parent
  (_fun _git_revwalk -> _void))

(define-libgit2 git_revwalk_sorting
  (_fun _git_revwalk _git_sort_t -> _void))
