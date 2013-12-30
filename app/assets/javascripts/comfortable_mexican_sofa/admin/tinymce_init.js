window.CMS.wysiwyg = function () {
  tinymce.init({
    plugins: "autolink link image autoresize",
    autoresize_min_height: 100,
    selector: "textarea[data-cms-rich-text]",
    height: 200
  });
}
