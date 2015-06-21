(function() {
  'use strict';

  angular
    .module('app', ['ngCookies', 'ngMaterial'])
    .controller('MainController', MainController);

  MainController.$inject = ['$scope', '$cookies', '$mdSidenav', '$mdToast', '$mdDialog'];
  function MainController($scope, $cookies, $mdSidenav, $mdToast, $mdDialog) {
    console.log('MainController loaded');

    var vm = $scope;
    vm.currentQuestion = parseInt($cookies.get('currentQuestion') || 0);
    vm.submit = submit;
    vm.toastPosition = {bottom: false, top: true, left: false, right: true};
    vm.showSuccess = false;
    vm.showError = false;

    vm.questions = [{
      intro: 'This is a test quiz. Let us konw that system works. What is 1 + 1?',
      answer: '',
      answers: ['2']
    }, {
      intro: 'We start our journey today in the district, named after Arthur Edward Kennedy, the 7th Governor of Hong Kong - Kennedy Town (堅尼地城). Find pier there and count pier poles!',
      img: 'pierpole.jpg',
      answer: '',
      answers: _.map(_.range(100), function(x){return x.toString();})
    }, {
      intro: 'Nobody in Hong Kong likes this place. It has three black buildings: one judges, one checks your taxes and another one works with foreigners. Find sculpture between them and count number of holes in it.',
      answer: '',
      answers: _.map(_.range(6, 10), function(x){return x.toString();})
    }, {
      intro: 'We are going to highest place in Hong Kong island, closer to sky! Right before observation desk there is a place selling ice-cream. Whom is this place named after?',
      answer: '',
      answers: ['Forrest Gump', 'forrest gump', 'Forrest gump']
    }, {
      intro: 'Our final destination is located on Des Voeux Road Central, however now we are going to Des Voeux Road West. Fing hotel IBIS there. On the ground floor there is a coffee shop, take on and chill a bit. By the way, what is the name of this shop?',
      img: 'ibis.jpg',
      answer: '',
      answers: ['Starbucks', 'starbucks']
    }];

    function submit() {
      console.log('submit');
      if(_.contains(vm.questions[vm.currentQuestion].answers, vm.questions[vm.currentQuestion].answer)) {
        console.log('answer correct');
        vm.currentQuestion++;
        $cookies.put('currentQuestion', vm.currentQuestion);

        $mdDialog.show(
          $mdDialog.alert()
          .title('This is correct!')
          .content('You could proceed to next question')
          .ariaLabel('Alert Dialog Demo')
          .ok('I knew it!')
        );
      } else {
        console.log('answer incorrect');

        $mdDialog.show(
          $mdDialog.alert()
          .title('Its wrong!')
          .content('How come? Think about answer more!')
          .ariaLabel('Alert Dialog Demo')
          .ok('Got it!')
        );
      }
    }
  }
})();
