angular.module("DatasetsResources").controller("DatasetsCtrl", ["$scope", function ($scope) {

  var countByContentType = function (datasets, contentTypes) {
    _.each(contentTypes, function (contentType) {
      contentType.count = _.where(datasets, {content_type: contentType.singular}).length;
    });
  }

  $scope.sortOrders = [
    {value: 0, name: "Most recent first"},
    {value: 1, name: "Alphabetically"}
  ];

  $scope.sortDatesets = function () {
    if ($scope.sortOrder === 0) {
      $scope.activeDatasets = _.sortBy($scope.activeDatasets, "publication_date").reverse();
    } else if ($scope.sortOrder === 1) {
      $scope.activeDatasets = _.sortBy($scope.activeDatasets, "title");
    }
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
    $scope.sortDatesets();
  }

  var initPublicationDates = function () {
    _.each($scope.datasets, function (dataset) {
      dataset.publication_date = Date.parse(dataset.publication_date);
    });
  }

  $scope.init = function (data) {
    $scope.sortOrder = $scope.sortOrders[0].value;
    $scope.datasets = data.datasets;
    $scope.contentTypes = data.content_types;
    countByContentType($scope.datasets, $scope.contentTypes);
    initPublicationDates();
    $scope.selectAll();
  }

  $scope.toggleContentType = function () {
    this.contentType.selected = !this.contentType.selected;
    applyFilters();
  }

}]);
