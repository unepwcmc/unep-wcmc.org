angular.module('EmployeesSearch', []).controller('SearchCtrl', ['$scope', function ($scope) {
  
  // caching the sections selector
  var sections = $('section.programme-wrapper');
  $('.search-field > input').keyup( function () {
    sections.each( function() {
      var section = $(this);
      if (section.find('section.group.staff').length === 0) {
        section.hide();
      } else {
        section.show();
      }
    });
  });

  $scope.query = "";
  $scope.matchName = function (name) {
    return name.indexOf($scope.query) >= 0;
  }

}]);
