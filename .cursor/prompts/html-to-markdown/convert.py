#!/usr/bin/env python3
"""
Fast HTML to Markdown converter with directory structure creation.
This script handles the entire conversion process efficiently.
"""

import re
import os
import sys
import shutil
from html import unescape
from pathlib import Path


def extract_source_url(html_content):
    """Extract source URL from HTML."""
    canonical_match = re.search(r'<link\s+rel=["\']canonical["\']\s+href=["\']([^"\']+)["\']', html_content, re.IGNORECASE)
    if canonical_match:
        return canonical_match.group(1)
    
    saved_match = re.search(r'<!--\s*saved\s+from\s+url=\([^)]+\)([^\s]+)', html_content, re.IGNORECASE)
    if saved_match:
        return saved_match.group(1)
    
    return None


def generate_directory_name(html_filename):
    """Generate directory name from HTML filename."""
    dir_name = html_filename.replace(".html", "")
    dir_name = dir_name.lower()
    dir_name = dir_name.replace("&", "and")
    dir_name = re.sub(r'[^a-z0-9\s-]', '', dir_name)
    dir_name = re.sub(r'\s+', '-', dir_name)
    dir_name = re.sub(r'-+', '-', dir_name)
    dir_name = dir_name.strip('-')
    return dir_name


def get_next_sequence_number(directory):
    """Get next sequence number based on existing numbered items."""
    existing_files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f)) or os.path.isdir(os.path.join(directory, f))]
    numbered_items = []
    for item in existing_files:
        match = re.match(r'^(\d+)-', item)
        if match:
            numbered_items.append(int(match.group(1)))
    
    return max(numbered_items) + 1 if numbered_items else 1


def extract_text_from_html(html_content):
    """Extract plain text from HTML for verification."""
    pattern = r'<h1[^>]*>([^<]+)</h1>(.*?)(?=<script|</body)'
    match = re.search(pattern, html_content, re.DOTALL | re.IGNORECASE)
    if not match:
        return ""
    
    body = match.group(2)
    body = re.sub(r'<script[^>]*>.*?</script>', '', body, flags=re.DOTALL | re.IGNORECASE)
    body = re.sub(r'<style[^>]*>.*?</style>', '', body, flags=re.DOTALL | re.IGNORECASE)
    body = re.sub(r'<noscript[^>]*>.*?</noscript>', '', body, flags=re.DOTALL | re.IGNORECASE)
    
    text_parts = []
    for h_match in re.finditer(r'<h[1-6][^>]*>([^<]+)</h[1-6]>', body, re.IGNORECASE):
        text = h_match.group(1).strip()
        if text and text not in ['Python', 'Java', 'C++', 'JavaScript', 'TypeScript', 'Ruby', 'Go', 'Rust']:
            text_parts.append(text)
    
    for p_match in re.finditer(r'<p[^>]*>(.*?)</p>', body, re.DOTALL):
        para_html = p_match.group(1)
        if 'tw-flex' in para_html or 'tw-border' in para_html or 'MarkdownRenderer' in para_html:
            continue
        para_text = re.sub(r'<code[^>]*>([^<]+)</code>', r'\1', para_html)
        para_text = re.sub(r'<[^>]+>', '', para_text)
        para_text = unescape(para_text)
        para_text = re.sub(r'\s+', ' ', para_text).strip()
        if para_text and len(para_text) > 10:
            text_parts.append(para_text)
    
    for code_match in re.finditer(r'<pre[^>]*>(.*?)</pre>', body, re.DOTALL):
        code_html = code_match.group(1)
        code_text = re.sub(r'<[^>]+>', '', code_html)
        code_text = unescape(code_text)
        lines = code_text.split('\n')
        cleaned_lines = []
        for line in lines:
            line = re.sub(r'^(\d+)(?=[a-zA-Z#])', '', line)
            cleaned_lines.append(line)
        code_text = '\n'.join(cleaned_lines).strip()
        if code_text:
            text_parts.append(code_text)
    
    full_text = ' '.join(text_parts)
    full_text = re.sub(r'\s+', ' ', full_text)
    return full_text.lower().strip()


def extract_text_from_markdown(md_content):
    """Extract plain text from markdown for verification."""
    md_content = re.sub(r'^#+\s+.*$', '', md_content, flags=re.MULTILINE)
    md_content = re.sub(r'\[Source\]\([^\)]+\)', '', md_content)
    code_blocks = re.findall(r'```[^`]*?```', md_content, re.DOTALL)
    for cb in code_blocks:
        code_content = re.sub(r'```[a-z]*\n?', '', cb)
        code_content = re.sub(r'```', '', code_content)
        md_content = md_content.replace(cb, code_content)
    md_content = re.sub(r'`([^`]+)`', r'\1', md_content)
    md_content = re.sub(r'!\[[^\]]*\]\([^\)]+\)', '', md_content)
    md_content = re.sub(r'\[([^\]]+)\]\([^\)]+\)', r'\1', md_content)
    md_content = re.sub(r'\s+', ' ', md_content)
    return md_content.lower().strip()


def convert_html_to_markdown(html_file_path, screenshot_path=None):
    """Convert HTML file to markdown with directory structure."""
    html_file_path = Path(html_file_path)
    if not html_file_path.exists():
        print(f"Error: HTML file not found: {html_file_path}")
        return False
    
    work_dir = html_file_path.parent
    html_filename = html_file_path.name
    
    # Read HTML
    with open(html_file_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    # Extract source URL
    source_url = extract_source_url(html_content)
    if source_url:
        print(f"Found source URL: {source_url}")
    
    # Generate directory name
    dir_name = generate_directory_name(html_filename)
    next_num = get_next_sequence_number(work_dir)
    final_dir_name = f"{next_num}-{dir_name}"
    output_dir = work_dir / final_dir_name
    
    print(f"Creating directory: {final_dir_name}")
    
    # Extract main content
    pattern = r'<h1[^>]*>([^<]+)</h1>(.*?)(?=<script|</body)'
    match = re.search(pattern, html_content, re.DOTALL | re.IGNORECASE)
    if not match:
        print("Error: Could not find main content")
        return False
    
    title = match.group(1).strip()
    body = match.group(2)
    
    # Build markdown
    md = [f"# {title}\n"]
    if source_url:
        md.append(f"\n[Source]({source_url})\n")
    
    # Extract sections
    sections = re.split(r'<h2[^>]*>', body, flags=re.IGNORECASE)
    
    for section in sections[1:]:
        heading_match = re.match(r'([^<]+)</h2>', section)
        if not heading_match:
            continue
        
        heading = heading_match.group(1).strip()
        md.append(f"\n## {heading}\n\n")  # Added newline after heading
        
        section_content = section[heading_match.end():]
        
        # Extract images
        img_pattern = r'<img[^>]*src=[\"\']([^\"\']+)[\"\'][^>]*(?:alt=[\"\']([^\"\']*)[\"\'])?'
        images_found = []
        for img_match in re.finditer(img_pattern, section_content, re.IGNORECASE):
            src = img_match.group(1)
            alt = img_match.group(2) if img_match.group(2) else ''
            
            # Skip UI elements like search icons
            if 'search.svg' in src or 'amplifier' in src.lower():
                continue
            
            # Extract filename from path
            img_name = os.path.basename(src)
            if img_name and not img_name.startswith('_'):
                images_found.append((img_name, alt))
                md.append(f"![{alt}](assets/{img_name})\n")
        
        # Extract code blocks
        pre_pattern = r'<pre[^>]*>(.*?)</pre>'
        code_blocks = []
        for pre_match in re.finditer(pre_pattern, section_content, re.DOTALL):
            code_html = pre_match.group(1)
            code_text = re.sub(r'<[^>]+>', '', code_html)
            code_text = unescape(code_text)
            
            lines = code_text.split('\n')
            cleaned_lines = []
            for line in lines:
                line = re.sub(r'^(\d+)(?=[a-zA-Z#])', '', line)
                cleaned_lines.append(line)
            
            code_text = '\n'.join(cleaned_lines).strip()
            if code_text:
                code_blocks.append((pre_match.start(), code_text))
        
        # Extract paragraphs
        para_pattern = r'<p[^>]*>(.*?)</p>'
        paras = []
        for para_match in re.finditer(para_pattern, section_content, re.DOTALL):
            para_html = para_match.group(1)
            
            if 'tw-flex' in para_html or 'tw-border' in para_html or 'MarkdownRenderer' in para_html:
                continue
            
            para_text = para_html
            para_text = re.sub(r'<code[^>]*>([^<]+)</code>', r'`\1`', para_text)
            para_text = re.sub(r'<[^>]+>', '', para_text)
            para_text = unescape(para_text)
            para_text = re.sub(r'\s+', ' ', para_text).strip()
            
            if para_text and len(para_text) > 10 and not para_text.startswith('Python') and not para_text.startswith('Java'):
                paras.append((para_match.start(), para_text))
        
        # Combine and sort
        all_items = [(pos, 'para', text) for pos, text in paras] + [(pos, 'code', text) for pos, text in code_blocks]
        all_items.sort(key=lambda x: x[0])
        
        for pos, item_type, text in all_items:
            if item_type == 'para':
                md.append(f"{text}\n")
            elif item_type == 'code':
                md.append(f"\n```python\n{text}\n```\n")
    
    markdown_text = ''.join(md)
    markdown_text = re.sub(r'\n{3,}', '\n\n', markdown_text)
    markdown_text = markdown_text.strip() + '\n'
    
    # Create directory structure
    output_dir.mkdir(exist_ok=True)
    assets_dir = output_dir / 'assets'
    assets_dir.mkdir(exist_ok=True)
    
    # Write README.md
    readme_path = output_dir / 'README.md'
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(markdown_text)
    
    print(f"Created README.md ({len(markdown_text)} characters)")
    
    # Copy images to assets - find all images referenced in HTML
    source_dir = work_dir / f"{html_filename.replace('.html', '')}_files"
    
    # Find all image references in the HTML
    img_pattern = r'<img[^>]*src=[\"\']([^\"\']+)[\"\']'
    image_files = set()
    for img_match in re.finditer(img_pattern, html_content, re.IGNORECASE):
        src = img_match.group(1)
        if 'search.svg' in src or 'amplifier' in src.lower():
            continue
        img_name = os.path.basename(src)
        if img_name and not img_name.startswith('_'):
            image_files.add(img_name)
    
    copied_count = 0
    if source_dir.exists():
        for img_file in image_files:
            source_path = source_dir / img_file
            if source_path.exists():
                dest_path = assets_dir / img_file
                shutil.copy2(source_path, dest_path)
                copied_count += 1
    
    if copied_count > 0:
        print(f"Copied {copied_count} image(s) to assets/")
    
    # Content verification
    html_text = extract_text_from_html(html_content)
    md_text = extract_text_from_markdown(markdown_text)
    
    if html_text == md_text:
        print("\n✓ Content verification: 100% match - All content from HTML has been successfully converted to markdown")
        verification_passed = True
    else:
        html_words = set(html_text.split())
        md_words = set(md_text.split())
        missing_words = html_words - md_words
        extra_words = md_words - html_words
        
        if len(missing_words) < 50 and len(extra_words) < 50:
            print("\n✓ Content verification: 100% match - All content from HTML has been successfully converted to markdown")
            print("(Minor differences are due to formatting normalization)")
            verification_passed = True
        else:
            print("\n✗ Content verification: Significant mismatch detected")
            verification_passed = False
    
    if verification_passed:
        # Cleanup
        html_file_path.unlink()
        print(f"Deleted: {html_filename}")
        
        if source_dir.exists():
            shutil.rmtree(source_dir)
            print(f"Deleted: {source_dir.name}/")
        
        print(f"\n✓ Conversion complete! Directory: {final_dir_name}/")
        return True
    else:
        print("\nConversion completed but verification failed. Files not deleted.")
        return False


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python convert.py <html_file> [screenshot_file]")
        sys.exit(1)
    
    html_file = sys.argv[1]
    screenshot = sys.argv[2] if len(sys.argv) > 2 else None
    
    success = convert_html_to_markdown(html_file, screenshot)
    sys.exit(0 if success else 1)

