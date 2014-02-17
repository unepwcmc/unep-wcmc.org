angular.module('stats').controller('StatsCtrl', [
  '$scope',
  '$rootScope',
  '$sce',
  'country',
function ($scope, $rootScope, $sce, country) {
  $scope.visible = false;
  $rootScope.$on('stats.visible', function(evt, args) {
    $scope.visible = true;
  });
}]);


angular.module('stats').controller('GeoIpCtrl', [
  '$scope',
  '$rootScope',
  '$resource',
  'GEOIP_URL',
  'countryService',
function ($scope, $rootScope, $resource, GEOIP_URL, countryService) {
  var GeoIp, geoIp;
  $scope.country = {};
  $scope.country.loaded = false;
  GeoIp = $resource(GEOIP_URL);
  geoIp = GeoIp.get( function(data) {
    var name = data.country_name,
      iso2 = data.country_code2;
    if (name && iso2) {
      $scope.country.name = data.country_name;
      $scope.country.iso2 = data.country_code2;
      $scope.country.loaded = true;
      countryService.setCountry($scope.country);
    }
  });
  $scope
    .$watch(function () { return countryService.getCountry(); }, 
      function (newCountry, oldCountry) {
        if (oldCountry.iso2 && newCountry.iso2 && newCountry.iso2 !== oldCountry.iso2) {
          $scope.country.name = newCountry.name;
          $scope.country.iso2 = newCountry.iso2;
        }
    }, true);
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
  '$resource', 
  'GEO_ENTITIES_URL',
  'countryService',
function ($scope, $rootScope, $resource, GEO_ENTITIES_URL, countryService) {
  $scope.geo = {};
  var Geo = $resource(GEO_ENTITIES_URL, {geo_entity_types_set:'@gts'});
  Geo.get({gts: 2}, function(data) {
    $scope.geo.entities = data.geo_entities;
  });
  
  $scope.$watch('geo.current_iso2', function (newVal, oldVal) {
      if (oldVal === newVal || newVal === '') return;
      var country_name = _.find($scope.geo.entities, function(entity) {
          return entity.iso_code2 === newVal;
        }).name,
        country = {iso2: newVal, name: country_name}
      countryService.setCountry(country);
  }, true);

}]);


angular.module('stats').controller('SapiStatsCtrl', [
  '$scope',
  '$rootScope',
  '$resource',
  'SAPI_API_URL',
  'countryService',
function ($scope, $rootScope, $resource, SAPI_API_URL, countryService) {

  var Sapi = $resource(SAPI_API_URL, {country:'@country'});

  $scope
    .$watch(function () { return countryService.getCountry(); }, 
      function (newCountry, oldCountry) {
        if (newCountry.iso2 && newCountry.iso2 !== oldCountry.iso2) {
          $scope.sapi.loading = true;
          $scope.sapi.loaded = false;
          getData(newCountry.iso2);
        }
    }, true);

  $scope.sapi = {};
  // Show/Hide, TODO: anything better?
  $scope.sapi.loading = true;
  $scope.sapi.loaded = false;
  // Trade
  $scope.sapi.trade_export = true;
  $scope.sapi.trade_import = false;
  $scope.sapi.trade_title_export = 'Most exported species';
  $scope.sapi.trade_title_import = 'Most imported species';
  $scope.sapi.trade_title = $scope.sapi.trade_title_export;
  $scope.sapi.trade_selector_export = 'See exports';
  $scope.sapi.trade_selector_import = 'See imports';
  $scope.sapi.trade_selector = $scope.sapi.trade_selector_import;
  // Species
  $scope.sapi.species_cites_eu = true;
  $scope.sapi.species_cms = false;
  $scope.sapi.species_title_cites_eu = 'Top cites eu listings';
  $scope.sapi.species_title_cms = 'Top cms listings';
  $scope.sapi.species_title = $scope.sapi.species_title_cites_eu;
  $scope.sapi.species_selector_cites_eu = 'See cites eu';
  $scope.sapi.species_selector_cms = 'See cms';
  $scope.sapi.species_selector = $scope.sapi.species_selector_cms;  

  $scope.toggleTrade = function () {
    if ($scope.sapi.trade_export) {
      $scope.sapi.trade_export = false;
      $scope.sapi.trade_import = true;
      $scope.sapi.trade_title = $scope.sapi.trade_title_import;
      $scope.sapi.trade_selector = $scope.sapi.trade_selector_export;
    } else {
      $scope.sapi.trade_export = true;
      $scope.sapi.trade_import = false;
      $scope.sapi.trade_title = $scope.sapi.trade_title_export;
      $scope.sapi.trade_selector = $scope.sapi.trade_selector_import;
    }
  }

  $scope.toggleSpecies = function () {
    if ($scope.sapi.species_cites_eu) {
      $scope.sapi.species_cites_eu = false;
      $scope.sapi.species_cms = true;
      $scope.sapi.species_title = $scope.sapi.species_title_cms;
      $scope.sapi.species_selector = $scope.sapi.species_selector_cites_eu;
    } else {
      $scope.sapi.species_cites_eu = true;
      $scope.sapi.species_cms = false;
      $scope.sapi.species_title = $scope.sapi.species_title_cites_eu;
      $scope.sapi.species_selector = $scope.sapi.species_selector_cms;  
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
    var species = data.dashboard_stats.species;
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
      data.dashboard_stats.species[taxonomy] = top_results;
    });
    return data;
  };

  function getData (iso2) {
    return Sapi.get({country:iso2, kingdom:'Animalia'}, function(data) {
      var data = getTopSpeciesResults(data, 5).dashboard_stats;
      $scope.sapi.species_cites_eu_data = data.species.cites_eu;
      $scope.sapi.species_cms_data = data.species.cms;
      $scope.sapi.trade_exports_top_data = data.trade.exports.top_traded;
      $scope.sapi.trade_imports_top_data = data.trade.imports.top_traded;
      $scope.sapi.loading = false;
      $scope.sapi.loaded = true;
    });
  }

}]);


angular.module('stats').controller('PpeStatsCtrl', [
  '$scope',
  '$rootScope',
  '$resource',
  '$q',
  'PPE_API_URL',
  'countryService',
  'carboStatsService',
function ($scope, $rootScope, $resource, $q, PPE_API_URL, countryService, carboStatsService) {

  var deferred = $q.defer();

  var Ppe = $resource(PPE_API_URL, {country:'@country'}),
    ppe_stored_carbon, 
    stored_carbon;

  $scope
    .$watch(function () { return countryService.getCountry(); }, 
      function (newCountry, oldCountry) {
        if (newCountry.iso2 && newCountry.iso2 !== oldCountry.iso2) {
          getData(newCountry.iso2);
        }
    }, true);
  $scope
    .$watch(function () { return carboStatsService.getCarboStats(); }, 
      function (newStats, oldStats) {
        if (newStats && newStats !== oldStats) {
          $scope.ppe.carbo_stats = newStats;
        }
    }, true);
  $scope.$watch('ppe.carbo_stats', function (newVal, oldVal) {
    if (newVal) {
      $scope.ppe
        .protected_areas_carbon_percent = ($scope.ppe.ppe_stored_carbon / newVal * 100)
          .toFixed(0);
    }
  }, true);

  $scope.ppe = {};
  $scope.ppe.loading = true;
  $scope.ppe.loaded = false;

  function getData (iso2) {
    var ppe_stored_carbon = void 0;
    return Ppe.get({iso:iso2}, function(data) {
      $scope.ppe.ppe_stored_carbon = data.carbon_kg_land / 1000;
      $scope.ppe.protected_areas_count = data.protected_areas_count;
      $scope.ppe.percentage_protected = data.percentage_protected.toFixed(0);
      $scope.ppe.loading = false;
      $scope.ppe.loaded = true;
      //$scope.ppe.protected_areas_carbon_percent = getCarbonRatio();
    });
  }

}]);


angular.module('stats').controller('CartodbStatsCtrl', [
  '$scope',
  '$rootScope',
  '$resource',
  'CARTODB_URL',
  'carboStatsService',
  'countryService',
function ($scope, $rootScope, $resource, CARTODB_URL, carboStatsService, countryService) {

  var Carbo = $resource(CARTODB_URL);

  $scope.carbo = {}
  $scope.carbo.loading = true;
  $scope.carbo.loaded = false;
  $scope.$watch(
    function () { return countryService.getCountry(); }, 
    function (newCountry, oldCountry) {
      if (newCountry.iso2 && newCountry.iso2 !== oldCountry.iso2) {
        getData(newCountry.iso2);
      }
  }, true);

  function getData (iso2) {
    var q = {
      q: "SELECT biodiversity_loss, carbon_sums FROM wcmc_api_stats WHERE iso2 = '" + iso2 + "'"
    }
    return Carbo.get(q, function(data) {
      var data = data.rows[0];
      if (data) {
        $scope.carbo.biodiversity_loss = -data.biodiversity_loss.toFixed(0);
        $scope.carbo.carbon_sums = data.carbon_sums;
        carboStatsService.setCarboStats(data.carbon_sums);
      }
      $scope.carbo.loading = false;
      $scope.carbo.loaded = true;
    });
  }

}]);