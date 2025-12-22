$files = Get-ChildItem -Path "." -Filter "*.html" | Where-Object { $_.Name -ne 'index.html' }

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Replace col-lg-3 with col-lg-4 in footer sections
    $content = $content -replace '(<div class="col-lg-)3( col-md-6">[\s\S]*?<h3 class="text-light mb-4">(?:Address|Services|Quick Links))', '$1 4$2'
    
    # Remove newsletter section completely
    $content = $content -replace '(?s)<div class="col-lg-[34] col-md-6">\s*<h3 class="text-light mb-4">Newsletter</h3>.*?</div>\s*(?=</div>\s*</div>\s*<div class="container-fluid copyright")', ''
    
    # Update Quick Links
    $content = $content -replace '(?s)(<h3 class="text-light mb-4">Quick Links</h3>).*?(?=</div>\s*(?:</div>\s*)?(?:<div class="col-lg-[34] col-md-6">|</div>\s*</div>\s*<div class="container-fluid copyright"))', @'
$1
                    <a class="btn btn-link" href="index.html">Home</a>
                    <a class="btn btn-link" href="about.html">About Us</a>
                    <a class="btn btn-link" href="service.html">Services</a>
                    <a class="btn btn-link" href="project.html">Projects</a>
                    <a class="btn btn-link" href="gallery.html">Gallery</a>
                    <a class="btn btn-link" href="contact.html">Contact Us</a>
                
'@
    
    # Update Services links
    $content = $content -replace '(<a class="btn btn-link" href=")("")(>(?:Architecture|3D Animation|House Planning|Interior Design|Construction)</a>)', '$1service.html$3'
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
}

Write-Host "Footer updated on all pages!"
