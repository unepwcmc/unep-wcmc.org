angular.module("ProjectsList").controller("ProjectsCtrl", ["$scope", function ($scope) {
  $scope.hiddenProjects = [];
  $scope.projects = [];
  $scope.init = function (projects) {
    $scope.hiddenProjects = projects;
    $scope.showMore();
  }

  $scope.showMore = function () {
    for (var i=0; i < 3 && $scope.hiddenProjects.length > 0; i++) {
      var project = $scope.hiddenProjects.shift();
      $scope.projects.push(project);
    }
  }
}]);
