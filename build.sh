#!/bin/sh
# Wraps shrinkwrap.html (the artifact source fragment) into a standalone index.html you can open or host anywhere.
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n</head>\n<body>\n'
  cat shrinkwrap.html
  printf '\n</body>\n</html>\n'
} > index.html
echo "built index.html"
