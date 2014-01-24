angular.module("EmployeesList", []).controller("EmployeeCtrl", ["$scope", function ($scope) {
  $scope.init = function (name) {
    this.name = name;
  }

  $scope.matchSearch = function () {
    var pattern = this.pattern || "";
    return this.name.indexOf(pattern.toLowerCase()) >= 0;
  }
}]);
