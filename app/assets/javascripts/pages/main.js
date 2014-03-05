angular.module('ProjectsList', ['ngAnimate']);
angular.module('DatasetsResources', []);

angular.module('stats', ['ngAnimate', 'ngResource', 'ui.select2', 'ui.bootstrap'])
  .constant('GEOIP_URL', my_url + '/api/geoip')
  .constant('PPE_API_URL', 'http://www.protectedplanet.net/api2/countries/')
  .constant('SAPI_API_URL', 'http://sapi.unepwcmc-012.vm.brightbox.net/api/v1/dashboard_stats/:country')
  .constant('GEO_ENTITIES_URL', 'http://sapi.unepwcmc-012.vm.brightbox.net/api/v1/geo_entities/')
  .constant('CARTODB_URL', 'https://carbon-tool.cartodb.com/api/v2/sql')
  .constant('SAPI_SPECIES_GROUPS', {
    'Mammals': ['Mammalia'],
    'Birds': ['Aves'],
    'Reptiles':  ['Reptilia'],
    'Amphibians':  ['Amphibia'],
    'Fish':  ['Actinopterygii', 'Elasmobranchii', 'Sarcopterygii'],
    'Invertebrates': ['Holothuroidea', 'Arachnida', 'Insecta', 'Hirudinoidea', 'Bivalvia', 'Gastropoda', 'Anthozoa', 'Hydrozoa']

  })
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