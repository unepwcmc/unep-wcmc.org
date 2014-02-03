angular.module('EmployeesSearch', []).controller('SearchCtrl', ['$scope', function ($scope) {
  $scope.query = "";
  $scope.matchName = function (name) {
    return name.indexOf($scope.query) >= 0;
  }
}]);
