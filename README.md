# PhotoCamel

PhotoCamel is a modern web application built with OCaml that allows users to upload photos to S3, automatically compress them into multiple formats, and share them via generated links. The application features a responsive web interface built with HTMX for dynamic interactions.

## Features

- Photo upload with drag-and-drop support
- Automatic image compression in three formats
- S3 storage integration
- Responsive web interface using HTMX and TailwindCSS
- Share photos via generated links
- Real-time UI updates without page refreshes

## Technology Stack

- **Backend**: OCaml with Dream web framework
- **Frontend**: HTMX + TailwindCSS
- **Storage**: Amazon S3
- **Image Processing**: ImageMagick
- **Database**: PostgreSQL
- **Template Engine**: Tyxml

## Project Structure

```
photocamel/
├── bin/                    # Application entry point
│   ├── main.ml            # Main application file
│   └── dune               # Binary build configuration
├── lib/                    # Core library code
│   ├── templates.ml       # HTML templates
│   └── dune               # Library build configuration
├── dune-project           # Project configuration
└── README.md              # This file
```

## Setup

1. Install OCaml and opam:
   ```bash
   # On Ubuntu/Debian
   sudo apt install opam
   opam init
   opam switch create 4.14.0
   eval $(opam env)
   ```

2. Install project dependencies:
   ```bash
   opam install . --deps-only
   ```

3. Configure AWS credentials:
   - Create a `.env` file with your AWS credentials:
     ```
     AWS_ACCESS_KEY_ID=your_access_key
     AWS_SECRET_ACCESS_KEY=your_secret_key
     AWS_REGION=your_region
     S3_BUCKET=your_bucket_name
     ```

4. Build the project:
   ```bash
   dune build
   ```

5. Run the application:
   ```bash
   dune exec photocamel
   ```

## Development

The application uses:
- HTMX for dynamic frontend interactions
- TailwindCSS for styling
- Dream for handling HTTP requests
- ImageMagick for image processing
- AWS S3 for storage

To add new features or modify existing ones:
1. Backend routes are defined in `bin/main.ml`
2. HTML templates are in `lib/templates.ml`
3. Build with `dune build`
4. Test with `dune test`

## Coming Soon

- User authentication
- Album organization
- Batch processing
- Image editing features
- Access control for shared links

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.