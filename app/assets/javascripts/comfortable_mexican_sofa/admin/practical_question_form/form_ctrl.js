angular.module("PracticalQuestionForm", []).controller("FormCtrl", ["$scope", function ($scope) {

  $scope.removeForm = function () {
    if (this.form.id) {
      this.form.removed = true;
    } else {
      $scope.forms.splice($scope.forms.indexOf(this.form), 1);
    }
  }

  $scope.init = function (fields) {
    $scope.forms = fields;
  }

  $scope.formIndex = function () {
    return $scope.forms.indexOf(this.form);
  }

  $scope.addField = function () {
    $scope.forms.push({
      type: "FileField",
      label: ""
    });
  }

}]);
