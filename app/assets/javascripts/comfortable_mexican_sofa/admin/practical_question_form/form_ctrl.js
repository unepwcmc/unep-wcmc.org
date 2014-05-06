angular.module("PracticalQuestionForm", []).controller("FormCtrl", ["$scope", function ($scope) {

  $scope.removeFieldForm = function () {
    if (this.form.id) {
      this.form.removed = true;
    } else {
      $scope.fieldForms.splice($scope.fieldForms.indexOf(this.form), 1);
    }
  }

  $scope.removeAttachmentForm = function () {
    if (this.form.id) {
      this.form.removed = true;
    } else {
      $scope.attachmentForms.splice($scope.attachmentForms.indexOf(this.form), 1);
    }
  }

  $scope.removeVacancyFieldForm = function (form_index) {
    $scope.vacancyFieldForms[form_index].removed = true;
  }

  $scope.showLabelInput = function(form) {
    return (form.label == 'Custom label');
  }

  $scope.init = function (fields, attachments, vacancyFields) {
    $scope.fieldForms = fields;
    $scope.attachmentForms = attachments;
    $scope.vacancyFieldForms = vacancyFields;
    $scope.vacancyFieldSelectDefaultOptions = [
      "Job description",
      "Person specification"
    ];
    $scope.setCustomLabels($scope.vacancyFieldForms);
  }

  $scope.fieldFormIndex = function () {
    return $scope.fieldForms.indexOf(this.form);
  }

  $scope.attachmentFormIndex = function () {
    return $scope.attachmentForms.indexOf(this.form);
  }

  $scope.vacancyFieldFormIndex = function () {
    return $scope.vacancyFieldForms.indexOf(this.form);
  }

  $scope.clearCustomLabel = function(form_index) {
    $scope.vacancyFieldForms[form_index].custom_label = "";
  }

  $scope.setCustomLabels = function (fieldForms) {
    angular.forEach(fieldForms, function(field, i) {
      $scope.isCustom = true;
      angular.forEach($scope.vacancyFieldSelectDefaultOptions, function(label, j){
        if (field.label == label) {
          $scope.isCustom = false;
        }
      });
      if ($scope.isCustom) {
        field.custom_label = field.label;
        field.label = 'Custom label';
      }
      field.removed = false;
    });
  }

  $scope.addField = function () {
    $scope.fieldForms.push({
      type: "FileField",
      label: ""
    });
  }

  $scope.addAttachment = function () {
    $scope.attachmentForms.push({
      name: ""
    });
  }

  $scope.addVacancyField = function () {
    $scope.vacancyFieldForms.push({
      label: ""
    });
  }

}]);
