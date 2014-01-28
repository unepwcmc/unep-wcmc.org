angular.module("EmployeesForm", ["ui.select2"]).controller("EmployeesCtrl", ["$scope", function ($scope) {

  $scope.removeForm = function () {
    $scope.forms.splice($scope.forms.indexOf(this.form), 1);
  }

  $scope.init = function (employees, employments) {
    $scope.forms = employments;
    $scope.employees = employees;
  }

  $scope.formIndex = function () {
    return $scope.forms.indexOf(this.form);
  }

  $scope.addEmployee = function () {
    $scope.forms.push({
      role: "",
      employee_id: $scope.employees[0].id
    });
  }

}]);
