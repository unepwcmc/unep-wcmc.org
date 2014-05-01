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

  function updateActiveContentTypesFromNames (names) {
    $scope.activeContentTypes = [];
    _.each(names, function (name) {
      $scope.activeContentTypes.push(
        _.findWhere($scope.contentTypes, {singular: name})
      ); 
    });
  }

  function updateActiveContentTypes (contentType) {
    if (contentType.selected) {
      $scope.activeContentTypes.push(contentType);
    } else {
      $scope.activeContentTypes.splice(
        _.findIndex($scope.activeContentTypes, function(o) {
          return contentType.$$hashKey == o.$$hashKey;
        }), 1
      );
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
    var activeContentTypeNames;
    $scope.activeDatasets = [];
    _.each($scope.foundDatasets, function (dataset) {
      var contentType = _.findWhere($scope.contentTypes, {singular: dataset.content_type});
      if (contentType.selected) {
        $scope.activeDatasets.push(dataset);
      }
    });
    activeContentTypeNames = _.uniq(
      _.map($scope.activeDatasets, function(o) {return o.content_type})
    );
    updateActiveContentTypesFromNames(activeContentTypeNames);
    $scope.sortDatesets();
    $scope.setHiddenDatasets();
  }

  $scope.sortDatesets = function () {
    if ($scope.sortOrder === 0) {
      $scope.activeDatasets = _.sortBy($scope.activeDatasets, function(dataset) {
        return [dataset.publication_date, dataset.title].join("_");
      }).reverse();
    } else if ($scope.sortOrder === 1) {
      $scope.activeDatasets = _.sortBy($scope.activeDatasets, "title");
    }
  }

  $scope.sortDatesetsToBeDisplayed = function () {
    if ($scope.sortOrder === 0) {
      $scope.datasetsToBeDisplayed = _.sortBy(
        $scope.datasetsToBeDisplayed, function(dataset) {
          return [dataset.publication_date, dataset.title].join("_");
      }).reverse();
    } else if ($scope.sortOrder === 1) {
      $scope.datasetsToBeDisplayed = _.sortBy($scope.datasetsToBeDisplayed, "title");
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

  $scope.showMore = function () {
    for (var i=0; i < 10 && $scope.hiddenDatasets.length > 0; i++) {
      var datasetItem = $scope.hiddenDatasets.shift();
      $scope.datasetsToBeDisplayed.push(datasetItem);
    }
  }

  $scope.setHiddenDatasets = function () {
    $scope.hiddenDatasets = [];
    $scope.datasetsToBeDisplayed = [];
    $scope.hiddenDatasets = _.clone($scope.activeDatasets);
    $scope.setInitialDatasets();
  }

  $scope.init = function (data, url_fields, file_fields) {
    $scope.sortOrder = $scope.sortOrders[0].value;
    $scope.query = "";
    $scope.datasets = data.datasets;
    $scope.hiddenDatasets = [];
    $scope.datasetsToBeDisplayed = [];
    $scope.contentTypes = data.content_types;
    initDatasets();
    $scope.selectAll();
    $scope.search();
    $scope.fileFields = file_fields;
    $scope.urlFields = url_fields;
    $scope.activeContentTypes = _.filter(data.content_types, function(o) {
      return o.count > 0;
    });
  }

  $scope.setInitialDatasets = function () {
    for (var i=0; i < 10 && $scope.hiddenDatasets.length > 0; i++) {
      var datasetItem = $scope.hiddenDatasets.shift();
      $scope.datasetsToBeDisplayed.push(datasetItem);
    }
  }

  $scope.urlFieldsForDataset = function (datasetId) {
    var fields = [];
    angular.forEach($scope.urlFields, function(field, i) {
      if (field.dataset_id == datasetId) {
        fields.push(field);
      }
    });
    return fields;
  }

  $scope.fileFieldsForDataset = function (datasetId) {
    var fields = [];
    angular.forEach($scope.fileFields, function(field, i) {
      if (field.dataset_id == datasetId) {
        fields.push(field);
      }
    });
    return fields;
  }

  $scope.toggleContentType = function () {
    var contentType = this.contentType;
    contentType.selected = !contentType.selected;
    updateActiveContentTypes(contentType);
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

  $scope.resetQuery = function () {
    if ($scope.query !== undefined) {
      $scope.query = '';
      $scope.search();
    }
  }

}]);
