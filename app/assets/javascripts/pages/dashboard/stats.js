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
  // Trade
  $scope.trade_export = true;
  $scope.trade_import = false;
  $scope.trade_title_export = 'Most exported species';
  $scope.trade_title_import = 'Most imported species';
  $scope.trade_title = $scope.trade_title_export;
  $scope.trade_selector_export = 'See exports';
  $scope.trade_selector_import = 'See imports';
  $scope.trade_selector = $scope.trade_selector_import;
  // Species
  $scope.species_cites_eu = true;
  $scope.species_cms = false;
  $scope.species_title_cites_eu = 'Top cites eu listings';
  $scope.species_title_cms = 'Top cms listings';
  $scope.species_title = $scope.species_title_cites_eu;
  $scope.species_selector_cites_eu = 'See cites eu';
  $scope.species_selector_cms = 'See cms';
  $scope.species_selector = $scope.species_selector_cms;  
  
  $rootScope.$on('geo.current_country', function(evt, args) {
    $scope.loading = true;
    $scope.loaded = false;
    getPromisedData(args);
  });

  $scope.toggleTrade = function () {
    if ($scope.trade_export) {
      $scope.trade_export = false;
      $scope.trade_import = true;
      $scope.trade_title = $scope.trade_title_import;
      $scope.trade_selector = $scope.trade_selector_export;
    } else {
      $scope.trade_export = true;
      $scope.trade_import = false;
      $scope.trade_title = $scope.trade_title_export;
      $scope.trade_selector = $scope.trade_selector_import;
    }
  }

  $scope.toggleSpecies = function () {
    if ($scope.species_cites_eu) {
      $scope.species_cites_eu = false;
      $scope.species_cms = true;
      $scope.species_title = $scope.species_title_cms;
      $scope.species_selector = $scope.species_selector_cites_eu;
    } else {
      $scope.species_cites_eu = true;
      $scope.species_cms = false;
      $scope.species_title = $scope.species_title_cites_eu;
      $scope.species_selector = $scope.species_selector_cms;  
    }
  }

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
      fetchData(SAPI_API_URL + current_country, {data: {kingdom: 'Animalia'}})
    ).then(
      function (data) {
        var data = getTopSpeciesResults(data, 5).taxon_concept_stats;
        $scope.species_cites_eu_data = data.species.cites_eu;
        $scope.species_cms_data = data.species.cms;
        $scope.trade_exports_top_data = data.trade.exports.top_traded;
        $scope.trade_imports_top_data = data.trade.imports.top_traded;
        $scope.loading = false;
        $scope.loaded = true;
        $scope.$apply();
      },
      function (err) {console.log(err)}
    );
  }
  getPromisedData();

}]);


angular.module('stats').controller('PpeStatsCtrl', [
  '$scope',
  '$rootScope',
  '$sce', 
  'fetchData', 
  'PPE_API_URL',
  'country',
function ($scope, $rootScope, $sce, fetchData, PPE_API_URL, country) {

  $scope.loading = true;
  $scope.loaded = false;
  
  $rootScope.$on('geo.current_country', function(evt, args) {
    $scope.loading = true;
    $scope.loaded = false;
    getPromisedData(args);
  });

  var getPromisedData = function (current_country) {
    current_country = (typeof current_country === "undefined") ? country : current_country;
    return $.when(
      fetchData(PPE_API_URL, {data: {iso: current_country}, credentials: true})
    ).then(
      function (data) {
        //var data = getTopSpeciesResults(data, 5).taxon_concept_stats;
        //$scope.species_cites_eu = data.species.cites_eu;
        //$scope.species_cms = data.species.cms;
        //$scope.trade_exports_top = data.trade.exports.top_traded;
        //$scope.trade_imports_top = data.trade.imports.top_traded;
        //$scope.loading = false;
        //$scope.loaded = true;
        //$scope.$apply();
        console.log(data);
      },
      function (err) {console.log(err)}
    );
  }
  getPromisedData();

}]);