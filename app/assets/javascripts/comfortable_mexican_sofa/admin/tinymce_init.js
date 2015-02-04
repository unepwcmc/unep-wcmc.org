window.CMS.wysiwyg = function () {
  tinymce.init({
    extended_valid_elements: "iframe[src|width|height|name|align]",
    plugins: "autolink link image autoresize media paste anchor",
    toolbar: "undo redo | bold italic underline | styleselect | blockquote | link anchor image | bullist numlist",
    paste_as_text: true,
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

