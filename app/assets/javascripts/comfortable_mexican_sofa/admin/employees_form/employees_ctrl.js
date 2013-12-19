angular.module("EmployeesForm", []).controller("EmployeesCtrl", ["$scope", function ($scope) {

  $scope.removeForm = function () {
    $scope.forms.splice($scope.forms.indexOf(this.form), 1);
  }

  $scope.init = function (employees, employments) {
    console.log(employments);
    $scope.forms = employments;
    $scope.employees = employees;
  }

  $scope.formIndex = function () {
    return $scope.forms.indexOf(this.form);
  }

  $scope.addEmployee = function () {
    console.log($scope.employees)
    $scope.forms.push({
      role: "",
      employee_id: $scope.employees[0].id
    });
  }

  $scope.logger = function () {
    console.log(this.form);
  }

}]);
