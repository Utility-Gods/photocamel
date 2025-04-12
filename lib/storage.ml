open Lwt.Syntax

(* Configuration type for B2 storage *)
type config = {
  key_id: string;
  application_key: string;
  bucket: string;
  endpoint: string;  (* Backblaze endpoint, e.g., "s3.us-west-002.backblazeb2.com" *)
  region: string;    (* Usually "us-west-002" for Backblaze *)
}

(* Initialize AWS library with Backblaze configuration *)
let init_storage config =
  let module B2 = Aws_s3.Make(struct
    let region = config.region
    let endpoint = Some config.endpoint
  end) in
  let credentials = Aws_s3.Credentials.make 
    ~access_key:config.key_id 
    ~secret_key:config.application_key
    () in
  B2.make_client ~credentials ()

(* Generate a unique filename for uploaded image *)
let generate_filename original_name =
  let extension = Filename.extension original_name in
  let uuid = Uuidm.v4_gen (Random.State.make_self_init ()) () in
  Uuidm.to_string uuid ^ extension

(* Upload a file to B2 *)
let upload_file ~client ~config ~filename ~content_type ~data =
  let key = generate_filename filename in
  let* response = 
    client |> Aws_s3.put_object 
      ~bucket:config.bucket
      ~key
      ~content_type
      ~body:(`String data)
      () in
  match response with
  | Ok _ -> 
      let url = Printf.sprintf "https://%s/%s/%s" 
        config.endpoint config.bucket key in
      Lwt.return_ok url
  | Error e -> Lwt.return_error (`Upload_failed e)

(* Delete a file from B2 *)
let delete_file ~client ~config ~key =
  client |> Aws_s3.delete_object
    ~bucket:config.bucket
    ~key
    ()

(* Get a file's metadata from B2 *)
let get_file_metadata ~client ~config ~key =
  client |> Aws_s3.head_object
    ~bucket:config.bucket
    ~key
    ()

(* List files in a B2 bucket *)
let list_files ~client ~config ?prefix ?max_keys () =
  client |> Aws_s3.list_objects
    ~bucket:config.bucket
    ?prefix
    ?max_keys
    () 