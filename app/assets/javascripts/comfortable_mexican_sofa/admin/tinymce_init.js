window.CMS.wysiwyg = function () {
  tinymce.init({
    extended_valid_elements : "iframe[src|width|height|name|align]",
    plugins: "autolink link image autoresize media",
    autoresize_min_height: 100,
    selector: "textarea[data-cms-rich-text]",
    height: 200
  });
}
