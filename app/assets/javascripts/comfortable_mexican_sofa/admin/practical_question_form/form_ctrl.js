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

  $scope.init = function (fields, attachments) {
    $scope.fieldForms = fields;
    $scope.attachmentForms = attachments;
  }

  $scope.fieldFormIndex = function () {
    return $scope.fieldForms.indexOf(this.form);
  }

  $scope.attachmentFormIndex = function () {
    return $scope.attachmentForms.indexOf(this.form);
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

}]);
