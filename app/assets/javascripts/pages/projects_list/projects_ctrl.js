angular.module("ProjectsList").controller("ProjectsCtrl", ["$scope", "$sce", function ($scope, $sce) {
  $scope.hiddenProjects = [];
  $scope.projects = [];
  $scope.init = function (projects) {
    $scope.hiddenProjects = projects;
    _.each(projects, function (project) {
      project.description = $sce.trustAsHtml(project.description);
    });
    $scope.showMore();
  }

  $scope.showMore = function () {
    for (var i=0; i < 3 && $scope.hiddenProjects.length > 0; i++) {
      var project = $scope.hiddenProjects.shift();
      $scope.projects.push(project);
    }
  }
}]);
