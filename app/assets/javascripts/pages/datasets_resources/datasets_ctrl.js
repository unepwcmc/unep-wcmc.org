angular.module("DatasetsResources").controller("DatasetsCtrl", ["$scope", "$sce", function ($scope, $sce) {

  lunr.stopWordFilter = function (word) { return word == "" ? undefined : word; }
  lunr.Pipeline.registerFunction(lunr.stopWordFilter, 'stopWordFilter')

  var index = lunr(function () {
    this.field('title', {boost: 10});
    this.field('content');
    this.ref('index');
  });

  var countByContentType = function () {
    _.each($scope.contentTypes, function (contentType) {
      contentType.count = _.where($scope.foundDatasets, {content_type: contentType.singular}).length;
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


  $scope.sortOrders = [
    {value: 0, name: "Most recent first"},
    {value: 1, name: "Alphabetically"}
  ];

  $scope.search = function () {
    if ($scope.query == "") {
      $scope.foundDatasets = _.map($scope.datasets, function (dataset) {return dataset;});
    } else {
      var results = index.search($scope.query);
      $scope.foundDatasets = _.map(results, function (res) { return $scope.datasets[parseInt(res.ref, 10)]; });
    }
    countByContentType();
    applyFilters();
  }

  var applyFilters = function () {
    $scope.activeDatasets = [];
    _.each($scope.foundDatasets, function (dataset) {
      var contentType = _.findWhere($scope.contentTypes, {singular: dataset.content_type});
      if (contentType.selected) {
        $scope.activeDatasets.push(dataset);
      }
    });
    $scope.sortDatesets();
  }

  $scope.sortDatesets = function () {
    if ($scope.sortOrder === 0) {
      $scope.activeDatasets = _.sortBy($scope.activeDatasets, "publication_date").reverse();
    } else if ($scope.sortOrder === 1) {
      $scope.activeDatasets = _.sortBy($scope.activeDatasets, "title");
    }
  }

  var initDatasets = function () {
    _.each($scope.datasets, function (dataset) {
      dataset.publication_date = Date.parse(dataset.publication_date);
      dataset.content = $sce.trustAsHtml(dataset.content);
    });
    for (var i=0; i<$scope.datasets.length; i++) {
      $scope.datasets[i].index = i;
      index.add($scope.datasets[i]);
    }
  }

  $scope.init = function (data) {
    $scope.sortOrder = $scope.sortOrders[0].value;
    $scope.query = "";
    $scope.datasets = data.datasets;
    $scope.contentTypes = data.content_types;
    initDatasets();
    $scope.selectAll();
    $scope.search();
  }

  $scope.toggleContentType = function () {
    this.contentType.selected = !this.contentType.selected;
    applyFilters();
  }

  $scope.noneSelected = function () {
    return !_.some($scope.contentTypes, function (type) {
      return type.selected && type.count > 0;
    });
  }

  $scope.allSelected = function () {
    return _.every($scope.contentTypes, function (type) {
      return type.selected || type.count === 0;
    });
  }

}]);
