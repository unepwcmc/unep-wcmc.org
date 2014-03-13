angular.module("DatasetFieldForm", []).controller("DatasetFieldCtrl", ["$scope", function ($scope) {
  
  $scope.removeUrlFieldForm = function (form_index) {
    $scope.urlFieldForms[form_index].removed = true;
  }

  $scope.removeFileFieldForm = function (form_index) {
    $scope.fileFieldForms[form_index].removed = true;
  }

  $scope.showLabelInput = function(form) {
    return (form.label == 'Custom label');
  }

  $scope.init = function (urlFields, fileFields) {
    $scope.urlFieldForms = urlFields;
    $scope.fileFieldForms = fileFields;
    $scope.urlSelectDefaultOptions = [
      "Access data at ArcGIS.com",
      "Read online",
      "View summary metadata",
      "Visit the site"
    ];
    $scope.setCustomLabels($scope.urlFieldForms, 'url');
    $scope.setCustomLabels($scope.fileFieldForms, 'file');
  }

  $scope.urlFieldFormIndex = function () {
    return $scope.urlFieldForms.indexOf(this.form);
  }

  $scope.fileFieldFormIndex = function () {
    return $scope.fileFieldForms.indexOf(this.form);
  }

  $scope.clearCustomLabel = function(form_index, type) {
    if (type == 'url') {
      $scope.urlFieldForms[form_index].custom_label = "";
    } else {
      $scope.fileFieldForms[form_index].custom_label = "";
    }
  }

  $scope.setCustomLabels = function (fieldForms, type) {
    angular.forEach(fieldForms, function(field, i) {
      $scope.isCustom = true;
      if (type == 'url') {
        angular.forEach($scope.urlSelectDefaultOptions, function(label, j){
          if (field.label == label) {
            $scope.isCustom = false;
          }
        }); 
      } else {
        if (field.label == "Download") {
          $scope.isCustom = false;
        }
      }
      if ($scope.isCustom) {
        field.custom_label = field.label;
        field.label = 'Custom label';
      }
      field.removed = false;
    });
  }

  $scope.addUrlField = function () {
    $scope.urlFieldForms.push({
      url: "",
      label: ""
    });
  }

  $scope.addFileField = function () {
    $scope.fileFieldForms.push({
      label: ""
    });
  }

}])
