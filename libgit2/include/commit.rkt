#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "repository.rkt"
         "tree.rkt"
         (submod "oid.rkt" private)
         (submod "repository.rkt" free) ;; TODO avoid this
         (only-in "types.rkt"
                  _git_repository
                  _git_time_t
                  _git_signature-pointer
                  _git_signature-pointer/null
                  _git_commit
                  _git_tree/null
                  _git_tree)
         "../private/buffer.rkt"
         "../private/base.rkt")

(provide (all-defined-out))


(define-libgit2/dealloc git_commit_free
  (_fun _git_commit -> _void))

(define-libgit2/check git_commit_amend
  (_fun _git_oid-pointer _git_commit _string _git_signature-pointer/null _git_signature-pointer/null _string _string _git_tree/null -> _int))

(define-libgit2 git_commit_author
  (_fun _git_commit -> _git_signature-pointer))

(define-libgit2 git_commit_body
  (_fun _git_commit -> _string))

(define-libgit2 git_commit_committer
  (_fun _git_commit -> _git_signature-pointer))

(define-libgit2/check git_commit_create
  (_fun _git_oid-pointer _git_repository _string _git_signature-pointer _git_signature-pointer _string _string _git_tree _size (_cpointer (_cpointer _git_commit)) -> _int))

(define-libgit2/check git_commit_create_buffer
  (_fun (_git_buf/bytes-or-null) _git_repository _git_signature-pointer _git_signature-pointer _string _string _git_tree _size (_cpointer (_cpointer _git_commit)) -> _int))

(define (git_commit_create_v id repo update_ref author committer encoding message tree parent_count . parents)
  (define itypes (append (list _git_oid-pointer _git_repository _string _git_signature-pointer _git_signature-pointer _string _string _git_tree _size)
                         (map (λ (i) _git_commit) (range (length parents)))))
  (let ([funct (get-ffi-obj "git_commit_create_v" #f (_cprocedure itypes _int))])
    (apply funct id repo update_ref author committer encoding message tree parent_count parents)))
#;(define-libgit2/check git_commit_create_v
    (_fun _oid _repository _string _signature _signature _string _string _tree _size -> _int))

(define-libgit2/check git_commit_create_with_signature
  (_fun _git_oid-pointer _git_repository _string _string _string -> _int))

(define-libgit2/alloc git_commit_dup
  (_fun _git_commit _git_commit -> _int)
  git_commit_free)

(define-libgit2/check git_commit_extract_signature
  (_fun (_git_buf/bytes-or-null) (_git_buf/bytes-or-null) _git_repository _git_oid-pointer _string -> _int))

(define-libgit2/check git_commit_header_field
  (_fun (_git_buf/bytes-or-null) _git_commit _string -> _int))

(define-libgit2 git_commit_id
  (_fun _git_commit -> _git_oid-pointer))

(define-libgit2/alloc git_commit_lookup
  (_fun _git_commit _git_repository _git_oid-pointer -> _int)
  git_commit_free)

(define-libgit2/alloc git_commit_lookup_prefix
  (_fun _git_commit _git_repository _git_oid-pointer _size -> _int)
  git_commit_free)

(define-libgit2 git_commit_message
  (_fun _git_commit -> _string))

(define-libgit2 git_commit_message_encoding
  (_fun _git_commit -> _string))

(define-libgit2 git_commit_message_raw
  (_fun _git_commit -> _string))

(define-libgit2/alloc git_commit_nth_gen_ancestor
  (_fun _git_commit _git_commit _uint -> _int)
  git_commit_free)

(define-libgit2 git_commit_owner
  (_fun _git_commit -> _git_repository)
  #:wrap (allocator git_repository_free))

(define-libgit2/alloc git_commit_parent
  (_fun _git_commit _git_commit _uint -> _int)
  git_commit_free)

(define-libgit2 git_commit_parent_id
  (_fun _git_commit _uint -> _git_oid-pointer))

(define-libgit2 git_commit_parentcount
  (_fun _git_commit -> _uint))

(define-libgit2 git_commit_raw_header
  (_fun _git_commit -> _string))

(define-libgit2 git_commit_summary
  (_fun _git_commit -> _string))

(define-libgit2 git_commit_time
  (_fun _git_commit -> _git_time_t))

(define-libgit2 git_commit_time_offset
  (_fun _git_commit -> _int))

(define-libgit2/alloc git_commit_tree
  (_fun _git_tree _git_commit -> _int)
  git_tree_free)

(define-libgit2 git_commit_tree_id
  (_fun _git_commit -> _git_oid-pointer))