;; This file was created by make-log-based-eval
((require libgit2 racket) ((3) 0 () 0 () () (c values c (void))) #"" #"")
((git_oid_fromstr "bda0839")
 ((3)
  0
  ()
  0
  ()
  ()
  (q
   exn
   "git_oid_fromstr: contract violation;\n given string is the wrong length\n  length: 7\n  expected: 40\n  given string: \"bda0839\"\n  in: the 1st argument of\n      (-> git-oid-string/c git_oid?)\n  contract from: \n      <pkgs>/libgit2/include/oid.rkt\n  blaming: top-level\n   (assuming the contract is correct)\n  at: <pkgs>/libgit2/include/oid.rkt:20:24"))
 #""
 #"")
((git_oid_fromstr (make-string GIT_OID_HEXSZ #\z))
 ((3)
  0
  ()
  0
  ()
  ()
  (q
   exn
   "git_oid_fromstr: \n  error code: 'GIT_ERROR\n  error class: 'GIT_ERROR_NONE"))
 #""
 #"")
((define a (git_oid_fromstr "555c0bd2b220e74e77a2d4ead659ffad79175dfa"))
 ((3) 0 () 0 () () (c values c (void)))
 #""
 #"")
((git_oid_equal a (git_oid_cpy a)) ((3) 0 () 0 () () (q values #t)) #"" #"")
(#t ((3) 0 () 0 () () (q values #t)) #"" #"")
((git_oid_is_zero (git_oid_fromstr (make-string GIT_OID_HEXSZ #\0)))
 ((3) 0 () 0 () () (q values #t))
 #""
 #"")
(#t ((3) 0 () 0 () () (q values #t)) #"" #"")
((git_oid_is_zero (git_oid_fromstr "555c0bd2b220e74e77a2d4ead659ffad79175dfa"))
 ((3) 0 () 0 () () (q values #f))
 #""
 #"")
(#f ((3) 0 () 0 () () (q values #f)) #"" #"")
((define str "7b70fdd9970245505229ef2127586350aaa8ad38")
 ((3) 0 () 0 () () (c values c (void)))
 #""
 #"")
((git_oid_equal (git_oid_fromstr str) (git_oid_fromstr str))
 ((3) 0 () 0 () () (q values #t))
 #""
 #"")
(#t ((3) 0 () 0 () () (q values #t)) #"" #"")
((git_oid_streq (git_oid_fromstr str) str)
 ((3) 0 () 0 () () (q values #t))
 #""
 #"")
(#t ((3) 0 () 0 () () (q values #t)) #"" #"")
((git_oid_streq
  (git_oid_fromstr str)
  "ad1b3cc099b788dcb066c56346fc8854e70e821c")
 ((3) 0 () 0 () () (q values #f))
 #""
 #"")
(#f ((3) 0 () 0 () () (q values #f)) #"" #"")
((git_oid_fmt (git_oid_fromstr "AD1B3CC099B788DCB066C56346FC8854E70E821C"))
 ((3) 0 () 0 () () (q values "ad1b3cc099b788dcb066c56346fc8854e70e821c"))
 #""
 #"")
("ad1b3cc099b788dcb066c56346fc8854e70e821c"
 ((3) 0 () 0 () () (q values "ad1b3cc099b788dcb066c56346fc8854e70e821c"))
 #""
 #"")
((define id (git_oid_fromstr "AD1B3CC099B788DCB066C56346FC8854E70E821C"))
 ((3) 0 () 0 () () (c values c (void)))
 #""
 #"")
((git_oid_nfmt id 6) ((3) 0 () 0 () () (q values "ad1b3c")) #"" #"")
("ad1b3c" ((3) 0 () 0 () () (q values "ad1b3c")) #"" #"")
((git_oid_pathfmt (git_oid_fromstr "40dc88bde003670bae6df1f0cffb1ffb5d93dee4"))
 ((3)
  0
  ()
  0
  ()
  ()
  (c values c (p+ #"40/dc88bde003670bae6df1f0cffb1ffb5d93dee4" . unix)))
 #""
 #"")
((define oid-strings
   (set
    "ad1b3cc099b788dcb066c56346fc8854e70e821c"
    "db775d20c1655c72a95dd40d1a75c0ad4f243461"
    "821ac0038a6b196a93c48182bdde5ac42c6f5b6e"
    "0000000000000000000000000000000000000000"
    "db785d20c1655c72a95dd40d1a75c0ad4f243461"
    "ad1b3cc099c788dcb066c56346fc8854e70e821c"))
 ((3) 0 () 0 () () (c values c (void)))
 #""
 #"")
((define min-length
   (let ((shortener (git_oid_shorten_new)))
     (for/last
      ((str (in-set oid-strings)))
      (git_oid_shorten_add shortener str))))
 ((3) 0 () 0 () () (c values c (void)))
 #""
 #"")
((sort
  (for/list ((str (in-set oid-strings))) (substring str 0 min-length))
  string<?)
 ((3)
  0
  ()
  0
  ()
  ()
  (c
   values
   c
   (c
    (u . "00000000000")
    c
    (u . "821ac0038a6")
    c
    (u . "ad1b3cc099b")
    c
    (u . "ad1b3cc099c")
    c
    (u . "db775d20c16")
    c
    (u . "db785d20c16"))))
 #""
 #"")
