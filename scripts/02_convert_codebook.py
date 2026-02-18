#!/usr/bin/env python3

import subprocess
import sys
import os

def convert_pdf_to_markdown(pdf_path, output_path):
    """
    Convert PDF codebook to markdown using pdftotext
    
    Args:
        pdf_path: Path to the PDF file
        output_path: Path to the output markdown file
    """
    try:
        # Use pdftotext to convert PDF to text
        result = subprocess.run(
            ['pdftotext', '-layout', pdf_path, output_path],
            capture_output=True,
            text=True,
            check=True
        )
        print(f"Successfully converted {pdf_path} to {output_path}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error converting PDF: {e}")
        print(f"stderr: {e.stderr}")
        return False
    except FileNotFoundError:
        print("Error: pdftotext not found. Please install poppler-utils:")
        print("  Ubuntu/Debian: sudo apt-get install poppler-utils")
        print("  macOS: brew install poppler")
        return False

if __name__ == "__main__":
    # Convert 2021 codebook
    pdf_file = "data/raw/ces_2021/ces_2021_codebook.pdf"
    md_file = "data/raw/ces_2021/ces_2021_codebook.md"
    
    if os.path.exists(pdf_file):
        success = convert_pdf_to_markdown(pdf_file, md_file)
        if success:
            print(f"Codebook converted successfully: {md_file}")
        else:
            sys.exit(1)
    else:
        print(f"Error: PDF file not found: {pdf_file}")
        sys.exit(1)
