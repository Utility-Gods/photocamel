# PhotoCamel Architecture

## Overview

PhotoCamel is built using a modern stack that combines OCaml's type safety with HTMX's simplicity for dynamic web interactions. Here's how the different pieces fit together:

## Server-Side Architecture (OCaml + Dream)

### 1. Web Server (Dream)
- Dream is a lightweight, fast web framework for OCaml
- Handles HTTP requests, routing, and middleware
- Provides built-in support for WebSocket and server-sent events
- Example route:
  ```ocaml
  get "/photos" (fun request ->
    let photos = get_photos_from_db () in
    html (Templates.photos_list photos))
  ```

### 2. Template Engine (Tyxml + Jingoo)
- **Tyxml**: Type-safe HTML generation
  - Catches HTML structure errors at compile time
  - Ensures valid HTML output
- **Jingoo**: Template engine similar to Jinja2
  - Allows for dynamic content in templates
  - Supports template inheritance and includes

### 3. Database Layer (Caqti)
- Caqti provides type-safe database queries
- PostgreSQL driver for robust data storage
- Connection pooling for performance

## Frontend Architecture (HTMX)

### 1. HTMX Integration
- HTMX allows for dynamic content updates without writing JavaScript
- Server sends HTML fragments that HTMX swaps into the DOM
- Example HTMX attribute:
  ```html
  <button 
    hx-post="/photos/like" 
    hx-target="#like-count"
    hx-swap="innerHTML">
    Like
  </button>
  ```

### 2. Dynamic Updates
- HTMX attributes trigger server requests
- Server responds with HTML fragments
- HTMX handles DOM updates automatically
- Common patterns:
  - Form submissions
  - Infinite scroll
  - Live search
  - Real-time updates

## Request Flow

1. **Initial Page Load**:
   ```
   Browser → Dream Server → Template Engine → HTML Response
   ```

2. **HTMX Interaction**:
   ```
   HTMX Request → Dream Server → Process → HTML Fragment → HTMX Updates DOM
   ```

3. **File Upload Flow**:
   ```
   HTMX Upload → Dream Server → Image Processing → S3 Storage → HTML Update
   ```

## Key Components

### 1. Templates (`lib/templates.ml`)
- Contains HTML templates using Tyxml
- Provides type-safe HTML generation
- Handles layout and component structure

### 2. Routes (`bin/main.ml`)
- Defines HTTP endpoints
- Handles request processing
- Coordinates between components

### 3. Image Processing
- Uses CamlImages for image manipulation
- Handles:
  - Resizing
  - Format conversion
  - Compression
  - Thumbnail generation

### 4. Storage Layer
- AWS S3 for image storage
- PostgreSQL for metadata and user data
- Local cache for performance

## Development Workflow

1. **Route Definition**:
   ```ocaml
   let () =
     Dream.run
     @@ Dream.router [
       get "/" (fun _ -> 
         let photos = [] in
         html (Templates.index photos))
     ]
   ```

2. **Template Creation**:
   ```ocaml
   let photo_card photo =
     div ~a:[a_class ["bg-white"; "shadow"]] [
       img ~src:photo.url ();
       div [txt photo.title]
     ]
   ```

3. **HTMX Integration**:
   ```html
   <div hx-get="/photos" 
        hx-trigger="revealed"
        hx-swap="afterend">
     <!-- Content -->
   </div>
   ```

## Benefits of This Architecture

1. **Type Safety**:
   - OCaml's type system catches errors at compile time
   - Tyxml ensures valid HTML structure
   - Caqti provides type-safe database queries

2. **Simplicity**:
   - HTMX eliminates need for complex JavaScript
   - Server-side rendering for better SEO
   - Direct HTML-over-the-wire updates

3. **Performance**:
   - Minimal JavaScript payload
   - Efficient DOM updates
   - OCaml's native speed
   - Connection pooling

4. **Developer Experience**:
   - Clear separation of concerns
   - Type-safe end-to-end development
   - Easy to debug (no complex client state)
   - Rapid development cycle 