open Dream

let () =
  run ~port:8081
  @@ logger
  @@ router [
    get "/" (fun _ ->
      let photos = [] in (* We'll implement photo loading later *)
      let page = Templates.index photos in
      Dream.html page);
    
    get "/upload" (fun _ ->
      let page = Templates.upload () in
      Dream.html page);
    
    post "/upload" (fun request ->
      match%lwt multipart request with
      | `Ok _parts ->
          (* We'll implement file upload later *)
          Dream.html "Upload successful"
      | _ ->
          Dream.html ~status:`Bad_Request "Invalid upload");
    
    (* Default route for handling 404s *)
    any "/**" (fun _ -> Dream.empty `Not_Found)
  ] 