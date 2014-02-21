angular.module('stats').controller('StatsCtrl', [
  '$scope',
  'statsVisibilityService',
function ($scope, statsVisibilityService) {
  $scope.visible = false;
  $scope.isCollapsed = true;
  $scope.$watch(
    function () { return statsVisibilityService.getVisibility(); }, 
    function (newVal, oldVal) {
      if (newVal && newVal !== oldVal) {
        $scope.isCollapsed = !newVal;
      }
  }, true);
}]);


angular.module('stats').controller('GeoIpCtrl', [
  '$rootScope',
  '$scope',
  '$resource',
  'GEOIP_URL',
  'countryService',
function ($rootScope, $scope, $resource, GEOIP_URL, countryService) {
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
  $scope.$watch(
    function () { return countryService.getCountry(); }, 
    function (newCountry, oldCountry) {
      if (oldCountry.iso2 && newCountry.iso2 && newCountry.iso2 !== oldCountry.iso2) {
        $scope.country.name = newCountry.name;
        $scope.country.iso2 = newCountry.iso2;
      }
  }, true);
}]);


angular.module('stats').controller('StatsBtnCtrl', [
  '$scope',
  'statsVisibilityService',
function ($scope, statsVisibilityService) {
  $scope.visible = true;
  $scope.showStats = function () {
    $scope.visible = false;
    statsVisibilityService.setVisibility(true);
  }
  $scope.$watch(
    function () { return statsVisibilityService.getVisibility(); }, 
    function (newVal, oldVal) {
      if (newVal && newVal !== oldVal) {
        $scope.visible = !newVal;
      }
  }, true);
}]);


angular.module('stats').controller('CountryPickerCtrl', [
  '$scope',
  '$http',
  'GEO_ENTITIES_URL',
  'countryService',
  'statsVisibilityService',
function ($scope, $http, GEO_ENTITIES_URL, countryService, statsVisibilityService) {

  $scope.selected = undefined;

  $scope.getCountry = function(val) {
    return $http.get(GEO_ENTITIES_URL, {
      params: {
        gst: 2
      }
    }).then(function(res){
      return _.filter(res.data.geo_entities, function(geo) {
        return geo.name.substr(0, val.length).toLowerCase() == val.toLowerCase();
      });
    });
  };
  
  $scope.$watch('selected', function (newVal, oldVal) {
    if (oldVal === newVal || newVal === '' || !newVal.name) return;

    countryService.setCountry({
      iso2: newVal.iso_code2, 
      name: newVal.name
    });
    if (statsVisibilityService.getVisibility() === false) {
      statsVisibilityService.setVisibility(true);
    }
    $scope.selected = '';

  }, true);

}]);


angular.module('stats').controller('SapiStatsCtrl', [
  '$scope',
  '$resource',
  'SAPI_API_URL',
  'countryService',
function ($scope, $resource, SAPI_API_URL, countryService) {

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
  $scope.sapi.trade_title_export = 'Top species by number of exports';
  $scope.sapi.trade_title_import = 'Top species by number of imports';
  $scope.sapi.trade_title = $scope.sapi.trade_title_export;
  $scope.sapi.trade_selector_export = 'See exports';
  $scope.sapi.trade_selector_import = 'See imports';
  $scope.sapi.trade_selector = $scope.sapi.trade_selector_import;
  // Species
  $scope.sapi.species_cites = false;
  $scope.sapi.species_title = 'Top classes by number of species listed in CITES';

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

  function spliceNoData (arr) {
    var len = arr.length, el;
    while (len--) {
      el = arr[len];
      if ( el.count === 0 ) {
        arr.splice(len, 1);
      }
    }
    return arr;
  }

  // For each taxonomy (cms, cites_eu) it selects the top most numerous groups.
  function getTopSpeciesResults (data, top, other) {
    var results = data.dashboard_stats.species, other_result, 
      other_results, sorted_results, filtered_results, top_results;
    sorted_results = results.sort( function( a, b) {
      return a.count - b.count;
    }).reverse();
    filtered_results = spliceNoData(sorted_results);
    top_results = filtered_results.slice(0, top);
    if (other) {
      other_result = getOtherSpeciesResults(sorted_results, top);
      top_results.push(other_result);
    }
    if (top_results[0].count === 0) {
      top_results = [];
    }
    data.dashboard_stats.species = top_results;
    return data;
  };

  function getData (iso2) {
    return Sapi.get({country:iso2, kingdom:'Animalia', trade_limit:5}, function(data) {
      var data = getTopSpeciesResults(data, 5).dashboard_stats;
      $scope.sapi.species_cites = data.species;
      $scope.sapi.trade_exports_top_data = data.trade.exports.top_traded;
      $scope.sapi.trade_imports_top_data = data.trade.imports.top_traded;
      $scope.sapi.loading = false;
      $scope.sapi.loaded = true;
    });
  }

}]);


angular.module('stats').controller('PpeStatsCtrl', [
  '$scope',
  '$resource',
  'PPE_API_URL',
  'countryService',
function ($scope, $resource, PPE_API_URL, countryService) {

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
    });
  }

}]);


angular.module('stats').controller('CartodbStatsCtrl', [
  '$scope',
  '$resource',
  'CARTODB_URL',
  'countryService',
function ($scope, $resource, CARTODB_URL, countryService) {

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
      q: "SELECT biodiversity_loss, carbon_sums, carbon_from_pas FROM wcmc_api_stats WHERE iso2 = '" + iso2 + "'"
    }
    return Carbo.get(q, function(data) {
      var data = data.rows[0];
      if (data) {
        $scope.carbo.biodiversity_loss = -data.biodiversity_loss.toFixed(0);
        $scope.carbo.carbon_sums = data.carbon_sums;
        $scope.carbo.carbon_pas = (data.carbon_from_pas / data.carbon_sums * 100).toFixed(0);
      }
      $scope.carbo.loading = false;
      $scope.carbo.loaded = true;
    });
  }

}]);