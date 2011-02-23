exe_path = Rails.root.join('bin', 'wkhtmltopdf.exe').to_s
WICKED_PDF = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => exe_path
}
