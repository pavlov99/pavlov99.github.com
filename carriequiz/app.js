(function() {
  'use strict';

  angular
    .module('app', ['ngCookies', 'ngMaterial'])
    .controller('MainController', MainController);

  MainController.$inject = ['$scope', '$cookies', '$mdSidenav'];
  function MainController($scope, $cookies, $mdSidenav) {
    console.log('MainController loaded');

    var vm = $scope;
    vm.currentQuestion = $cookies.get('currentQuestion') || 1;
    console.log(vm.currentQuestion);

    vm.toggleSidenav = function(menuId) {
      $mdSidenav(menuId).toggle();
    };
  }

})();
