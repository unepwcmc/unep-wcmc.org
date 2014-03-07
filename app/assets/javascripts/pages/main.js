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
  .service('sapiHelpers', function() {
    return {
      getStatSelections: function (s) {
        var selectors = {},
            $headers = $('div.stat.sapi > header'),
            $tables = $('div.stat.sapi table');
        selectors.$header_l = $headers[0],
        selectors.$header_r = $headers[1],
        selectors.$tables_l = $tables.slice(0, 2),
        selectors.$tables_r = $tables.slice(2);
        return selectors;
      },
      setVerticalAlignment: function (s) {
        var header_l = $(s.$header_l),
            header_r = $(s.$header_r),
            header_l_height = header_l.height(),
            header_r_height = header_r.height(),
            tr_l = $(s.$tables_l),
            tr_r = $(s.$tables_r),
            tr_l_height,
            tr_r_height;
        tr_l.each(function() {
          if ($(this).is(":visible")) {
            tr_l_height = $(this).find('tr').first().height();
          }
        });
        tr_r.each(function() {
          if ($(this).is(":visible")) {
            tr_r_height = $(this).find('tr').first().height();
          }
        });
        if (header_l_height > header_r_height) {
          header_r.height(header_l_height);
        } else if (header_l_height < header_r_height) {
          header_l.height(header_r_height);
        }
        if (tr_l_height < tr_r_height) {
          $(s.$tables_l).find('tr:visible').height(tr_r_height);
        } else if (tr_l_height > tr_r_height) {
          $(s.$tables_r).find('tr:visible').height(tr_l_height);
        }
      }
    }
  });