angular.module("DatasetFieldForm", []).controller("DatasetFieldCtrl", ["$scope", function ($scope) {
  
  $scope.removeUrlFieldForm = function () {
    $scope.urlFieldForms.splice($scope.urlFieldForms.indexOf(this.form), 1);
  }

  $scope.removeFileFieldForm = function () {
    $scope.fileFieldForms.splice($scope.fileFieldForms.indexOf(this.form), 1);
  }

  $scope.init = function (urlFields, fileFields) {
    $scope.urlFieldForms = urlFields;
    $scope.fileFieldForms = fileFields;
    $scope.urlLabelInput = false;
    $scope.fileLabelInput = false;
  }

  $scope.urlFieldFormIndex = function () {
    return $scope.urlFieldForms.indexOf(this.form);
  }

  $scope.fileFieldFormIndex = function () {
    return $scope.fileFieldForms.indexOf(this.form);
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
