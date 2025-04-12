type t = {
  b2_key_id: string;
  b2_application_key: string;
  b2_bucket: string;
  b2_endpoint: string;
  b2_region: string;
}

let get_env_var name =
  match Sys.getenv_opt name with
  | Some value -> Ok value
  | None -> Error (`Missing_env_var name)

let load () =
  let open Result in
  get_env_var "B2_KEY_ID" >>= fun b2_key_id ->
  get_env_var "B2_APPLICATION_KEY" >>= fun b2_application_key ->
  get_env_var "B2_BUCKET" >>= fun b2_bucket ->
  get_env_var "B2_ENDPOINT" >>= fun b2_endpoint ->
  get_env_var "B2_REGION" >>= fun b2_region ->
  Ok {
    b2_key_id;
    b2_application_key;
    b2_bucket;
    b2_endpoint;
    b2_region;
  }

let to_storage_config config = 
  Storage.{
    key_id = config.b2_key_id;
    application_key = config.b2_application_key;
    bucket = config.b2_bucket;
    endpoint = config.b2_endpoint;
    region = config.b2_region;
  } 