open Tyxml.Html
open Jingoo

type photo = {
  id: string;
  name: string;
  url: string;
}

let a_hx_get = Unsafe.string_attrib "hx-get"
let a_hx_target = Unsafe.string_attrib "hx-target"

let base_template ~title ~content =
  let doc = 
    html
      (head
        (Tyxml.Html.title (Tyxml.Html.txt title))
        [ meta ~a:[a_charset "UTF-8"] ();
          meta ~a:[a_name "viewport"; a_content "width=device-width, initial-scale=1.0"] ();
          script ~a:[a_src "https://unpkg.com/htmx.org@1.9.10"] (txt "");
          script ~a:[a_src "https://cdn.tailwindcss.com"] (txt "");
        ])
      (body ~a:[a_class ["bg-gray-100"]] [content])
  in
  Format.asprintf "%a" (pp ()) doc

let template_dir = "/home/d2du/code/ug/photocamel/lib/templates"

let render_template template_name vars =
  let template_path = Filename.concat template_dir template_name in
  Jg_template.from_file template_path ~models:vars

let index photos =
  let content =
    if List.length photos = 0 then
      div ~a:[a_class ["text-center"; "py-8"]] [
        p ~a:[a_class ["text-gray-500"; "text-lg"]] [
          txt "No photos yet. ";
          a ~a:[a_href "/upload"; a_class ["text-blue-500"; "hover:text-blue-600"]] [txt "Upload your first photo!"]
        ]
      ]
    else
      let photo_cards = List.map (fun photo ->
        div ~a:[a_class ["bg-white"; "rounded"; "shadow"; "p-4"]] [
          img ~src:photo.url ~alt:photo.name ~a:[a_class ["w-full"; "h-48"; "object-cover"; "mb-2"]] ();
          div ~a:[a_class ["flex"; "justify-between"; "items-center"]] [
            button ~a:[
              a_class ["text-blue-500"; "hover:text-blue-700"];
              a_hx_get (Printf.sprintf "/photo/%s/share" photo.id);
              a_hx_target "next .share-links"
            ] [txt "Share"];
            div ~a:[a_class ["share-links"]] []
          ]
        ]
      ) photos in
      div ~a:[a_class ["grid"; "grid-cols-1"; "md:grid-cols-3"; "gap-4"]] photo_cards
  in
  base_template ~title:"Photo Gallery" ~content

let upload () =
  let content =
    div ~a:[a_class ["max-w-2xl"; "mx-auto"]] [
      h1 ~a:[a_class ["text-2xl"; "font-bold"; "mb-6"]] [txt "Upload Photo"];
      form ~a:[
        a_action "/upload";
        a_method `Post;
        a_enctype "multipart/form-data";
        a_class ["space-y-6"]
      ] [
        div ~a:[a_class ["w-full"; "h-64"; "border-2"; "border-dashed"; "border-gray-300"; "rounded-lg"; "flex"; "flex-col"; "items-center"; "justify-center"; "cursor-pointer"; "hover:border-blue-500"; "transition-colors"]] [
          div ~a:[a_class ["w-12"; "h-12"; "text-gray-400"]] [
            div ~a:[
              a_class ["w-12"; "h-12"; "text-gray-400"];
              Unsafe.string_attrib "innerHTML" {|
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
              |}
            ] []
          ];
          p ~a:[a_class ["mt-2"; "text-sm"; "text-gray-600"]] [txt "Drag and drop your photo here, or click to select"];
          input ~a:[
            Unsafe.string_attrib "type" "file";
            a_name "photo";
            a_accept ["image/*"];
            a_class ["absolute"; "inset-0"; "w-full"; "h-full"; "opacity-0"; "cursor-pointer"]
          ] ()
        ];
        div ~a:[a_class ["flex"; "justify-end"]] [
          button ~a:[
            Unsafe.string_attrib "type" "submit";
            a_class ["bg-blue-500"; "hover:bg-blue-600"; "text-white"; "px-6"; "py-2"; "rounded"]
          ] [txt "Upload"]
        ]
      ]
    ]
  in
  base_template ~title:"Upload Photo" ~content 