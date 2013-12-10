angular.module("DatasetsResources").controller("DatasetsCtrl", ["$scope", function ($scope) {

  var countByContentType = function (datasets, contentTypes) {
    _.each(contentTypes, function (contentType) {
      contentType.count = _.where(datasets, {content_type: contentType.singular}).length;
    });
  }

  $scope.init = function (data) {
    $scope.datasets = data.datasets;
    $scope.contentTypes = data.content_types;
    countByContentType($scope.datasets, $scope.contentTypes);
  }
}]);
