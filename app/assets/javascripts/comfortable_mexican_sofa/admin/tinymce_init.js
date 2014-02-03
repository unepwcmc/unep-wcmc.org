window.CMS.wysiwyg = function () {
  tinymce.init({
    extended_valid_elements: "iframe[src|width|height|name|align]",
    plugins: "autolink link image autoresize media",
    toolbar: "bold italic underline | styleselect | blockquote",
    style_formats: [
      {title: "Paragraph", block: "p"},
      {title: "Header", block: "h3"}
    ],
    menubar: "edit insert",
    autoresize_min_height: 100,
    selector: "textarea[data-cms-rich-text]",
    height: 200
  });
}
