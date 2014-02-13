angular.module('ProjectsList', ['ngAnimate']);
angular.module('DatasetsResources', []);

angular.module('stats', ['ngAnimate', 'ui.select2'])
  .constant('PPE_API_URL', 'http://www.protectedplanet.net/api2/countries')
  //.constant('SAPI_API_URL', 'http://sapi.unepwcmc-012.vm.brightbox.net/api/v1/stats/')
  .constant('SAPI_API_URL', 'http://localhost:3600/api/v1/stats/')
  .constant('GEO_ENTITIES_URL', 'http://sapi.unepwcmc-012.vm.brightbox.net/api/v1/geo_entities/')
  .value('country', 'DE')
  .factory('fetchData', function() {
    return function (url, params) {
      params = (typeof params === "undefined") ? {} : params;
      return $.ajax({
        type: 'GET',
        dataType: 'json',
        url: url,
        data: params,
        xhrFields: {
          withCredentials: params.credentials ? true : false
        }
      });
    }

  })