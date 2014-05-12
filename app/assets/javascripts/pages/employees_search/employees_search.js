angular.module('EmployeesSearch', []).controller('SearchCtrl', ['$scope', function ($scope) {
  
  // caching the sections selectors
  var sections = $('section.programme-wrapper'),
      subsections = $('section.subprogramme-wrapper');

  function showHideSections (sections) {
    sections.each( function() {
      var section = $(this);
      if (section.find('section.group.staff').length === 0) {
        section.hide();
      } else {
        section.show();
      }
    });
  }

  $('.search-field > input').keyup( function () {
    showHideSections(sections);
    showHideSections(subsections);
  });

  $scope.query = "";
  $scope.matchName = function (name) {
    return name.indexOf($scope.query.toLowerCase()) >= 0;
  }

}]);
