(lang dune 3.0)
(name photocamel)
(version 0.1.0)

(generate_opam_files true)

(package
 (name photocamel)
 (synopsis "Photo management web application")
 (description "Web application to upload, compress, and share photos using S3 storage")
 (depends
  (ocaml (>= 4.14.0))
  (dune (>= 3.0.0))
  (dream (>= 1.0.0~alpha4))
  (caqti (>= 1.9.0))
  (caqti-driver-postgresql (>= 1.9.0))
  (yojson (>= 2.1.0))
  (ppx_deriving_yojson (>= 3.7.0))
  (ppx_deriving (>= 5.2.1))
  (aws-s3 (>= 4.7.0))
  (graphics (>= 5.1.2))
  (lwt (>= 5.6.1))
  (lwt_ppx (>= 2.1.0))
  (tyxml (>= 4.5.0))
  (uuidm (>= 0.9.8))
  odoc)) 