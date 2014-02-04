window.CMS.wysiwyg = function () {
  tinymce.init({
    extended_valid_elements: "iframe[src|width|height|name|align]",
    plugins: "autolink link image autoresize media",
    toolbar: "undo redo | bold italic underline | styleselect | blockquote | link image",
    style_formats: [
      {title: "Paragraph", block: "p"},
      {title: "Header 1", block: "h1"},
      {title: "Header 2", block: "h2"},
      {title: "Header 3", block: "h3"}
    ],
    menubar: "edit insert",
    autoresize_min_height: 100,
    selector: "textarea[data-cms-rich-text]",
    height: 200
  });
}
