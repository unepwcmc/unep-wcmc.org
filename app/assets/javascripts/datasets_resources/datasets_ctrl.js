angular.module("DatasetsResources").controller("DatasetsCtrl", ["$scope", function ($scope) {

  var countByContentType = function (datasets, contentTypes) {
    _.each(contentTypes, function (contentType) {
      contentType.count = _.where(datasets, {content_type: contentType.singular}).length;
    });
  }

  $scope.selectAll = function () {
    _.each($scope.contentTypes, function (contentType) {
      contentType.selected = true;
    });
    applyFilters();
  }

  $scope.deselectAll = function () {
    _.each($scope.contentTypes, function (contentType) {
      contentType.selected = false;
    });
    applyFilters();
  }

  var applyFilters = function () {
    $scope.activeDatasets = [];
    _.each($scope.datasets, function (dataset) {
      var contentType = _.findWhere($scope.contentTypes, {singular: dataset.content_type});
      if (contentType.selected) {
        $scope.activeDatasets.push(dataset);
      }
    });
  }

  $scope.init = function (data) {
    $scope.activeDatasets = data.datasets;
    $scope.datasets = data.datasets;
    $scope.contentTypes = data.content_types;
    countByContentType($scope.datasets, $scope.contentTypes);
    $scope.selectAll();
  }

  $scope.toggleContentType = function () {
    this.contentType.selected = !this.contentType.selected;
    applyFilters();
  }

}]);
