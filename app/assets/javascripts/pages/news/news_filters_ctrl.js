angular.module("NewsFilters").controller("NewsFiltersCtrl", [
  "$scope",
  "$sce",
  "$filter",

  function($scope, $sce, $filter){
    var initArticles = function(){
      var years = []

      _.each($scope.articles, function(article){
        var year = $filter('date')(article.date, 'yyyy');
        
        if(years.indexOf(year) < 0){
          years.push(year);
        }

        article.introduction = $sce.trustAsHtml(article.introduction);
        article.formattedDate = $filter('date')(article.date, 'dd MMMM yyyy');
        article.year = year;
        article.active = true;
      });

      createFilters(years);
    }

    var initToggleButton = function(){
      var button = {};
      button.text = 'Uncheck All';
      button.hideAll = true
      
      $scope.button = button;
    }

    var createFilters = function(years){
      var filters = [];

      _.each(years, function(year){
        var filter = {};
        filter.title = year
        filter.active = true
        filter.count = _.where($scope.articles, { year: filter.title }).length;

        filters.push(filter);
      });
      
      $scope.filters = filters;
    }

    var updateActiveState = function(object, state){
      _.each(object, function(o){
        o.active = state;
      })
    }

    $scope.init = function(data){
      $scope.articles = data.articles

      initArticles();
      initToggleButton();
    }

    $scope.toggleFilter = function(){
      var filter = this.filter;
      filter.active = !filter.active;

      affectedArticles = _.where($scope.articles, { year: filter.title });

      _.each(affectedArticles, function(article){
        article.active = !article.active
      });
    }

    $scope.toggleButton = function(){
      if(this.button.hideAll){

        $scope.button.text = 'Check all'
        updateActiveState($scope.filters, false);
        updateActiveState($scope.articles, false);
        
      } else {

        $scope.button.text = 'Uncheck all'
        updateActiveState($scope.filters, true);
        updateActiveState($scope.articles, true);
      }

      $scope.button.hideAll = !this.button.hideAll;
    }
  }
]);