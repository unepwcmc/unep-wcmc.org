angular.module('stats').controller('StatsCtrl', [
  '$scope',
  '$rootScope',
  '$sce',
function ($scope, $rootScope, $sce) {

  $scope.visible = false;
  $rootScope.$on('stats.visible', function(evt, args) {
    $scope.visible = true;
  });

}]);

angular.module('stats').controller('StatsBtnCtrl', [
  '$scope',
  '$rootScope',
  '$sce',
function ($scope, $rootScope, $sce) {

  $scope.visible = true;
  $scope.showStats = function () {
    $scope.visible = false;
    $rootScope.$emit('stats.visible', true);
  }

}]);

angular.module('stats').controller('CountryPickerCtrl', [
  '$scope',
  '$rootScope',
  '$sce', 
  'fetchData', 
  'GEO_ENTITIES_URL',
function ($scope, $rootScope, $sce, fetchData, GEO_ENTITIES_URL) {

  $scope.$watch('geo.current_country', function (newVal, oldVal) {
      if (oldVal === newVal || newVal === '') return;
      $rootScope.$emit('geo.current_country', newVal);
  }, true);

  var geo_entities_data = $.when(
    fetchData(GEO_ENTITIES_URL, {geo_entity_types_set: 2})
  ).then(
    function (data) {
      $scope.geo_entities = data.geo_entities;
      $scope.$apply();
    },
    function (err) {console.log(err)}
  );

}]);

angular.module('stats').controller('SapiStatsCtrl', [
  '$scope',
  '$rootScope',
  '$sce', 
  'fetchData', 
  'SAPI_API_URL',
  'country',
function ($scope, $rootScope, $sce, fetchData, SAPI_API_URL, country) {

  $scope.loading = true;
  $scope.loaded = false;
  
  $rootScope.$on('geo.current_country', function(evt, args) {
    $scope.loading = true;
    $scope.loaded = false;
    getPromisedData(args);
  });

  // Aggregates the least numerous groups.
  function getOtherSpeciesResults (sorted_results, top) {
    var other_results, other_result;
    other_results = sorted_results.slice(top);
    other_result = {
      common_name_en: 'other',
      count: 0
    };
    angular.forEach(other_results, function(result) {
      return other_result.count += result.count;
    });
    return other_result;
  }

  // For each taxonomy (cms, cites_eu) it selects the top most numerous groups.
  function getTopSpeciesResults (data, top, other) {
    var species = data.taxon_concept_stats.species;
    angular.forEach(species, function(results, taxonomy) {
      var other_result, other_results, sorted_results, top_results;
      sorted_results = results.sort( function( a, b) {
        return a.count - b.count;
      }).reverse();
      top_results = sorted_results.slice(0, top);
      if (other) {
        other_result = getOtherSpeciesResults(sorted_results, top);
        top_results.push(other_result);
      }
      if (top_results[0].count === 0) {
        top_results = [];
      }
      data.taxon_concept_stats.species[taxonomy] = top_results;
    });
    return data;
  };

  var getPromisedData = function (current_country) {
    current_country = (typeof current_country === "undefined") ? country : current_country;
    return $.when(
      fetchData(SAPI_API_URL + current_country, {kingdom: 'Animalia'})
    ).then(
      function (data) {
        var data = getTopSpeciesResults(data, 5).taxon_concept_stats;
        $scope.species_cites_eu = data.species.cites_eu;
        $scope.species_cms = data.species.cms;
        $scope.trade_exports_top = data.trade.exports.top_traded;
        $scope.trade_imports_top = data.trade.imports.top_traded;
        $scope.loading = false;
        $scope.loaded = true;
        $scope.$apply();
      },
      function (err) {console.log(err)}
    );
  }
  getPromisedData();

}]);