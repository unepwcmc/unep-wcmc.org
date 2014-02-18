angular.module('ProjectsList', ['ngAnimate']);
angular.module('DatasetsResources', []);

angular.module('stats', ['ngAnimate', 'ngResource', 'ui.select2'])
  .constant('GEOIP_URL', 'http://localhost:3000/api/geoip')
  .constant('PPE_API_URL', 'http://www.protectedplanet.net/api2/countries/')
  .constant('SAPI_API_URL', 'http://sapi.unepwcmc-012.vm.brightbox.net/api/v1/dashboard_stats/:country')
  .constant('GEO_ENTITIES_URL', 'http://sapi.unepwcmc-012.vm.brightbox.net/api/v1/geo_entities/')
  .constant('CARTODB_URL', 'https://carbon-tool.cartodb.com/api/v2/sql') 
  .value('country', 'GB')
  .service('statsVisibilityService', function() {
    var _visibility = false;
    return {
      getVisibility: function () {
        return _visibility;
      },
      setVisibility: function (value) {
        _visibility = value;
      }
    };
  })
  .service('countryService', function() {
    var _country = {};
    return {
      getCountry: function () {
        return _country;
      },
      setCountry: function (value) {
        _country = value;
      }
    };
  })
  .service('carboStatsService', function() {
    var _carbo_stats = {};
    return {
      getCarboStats: function () {
        return _carbo_stats;
      },
      setCarboStats: function (value) {
        _carbo_stats = value;
      }
    };
  })