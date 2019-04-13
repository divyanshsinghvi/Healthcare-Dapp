App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load pets.
    return await App.initWeb3();
  },

  initWeb3: async function() {
    /*
     * Replace me...
     */
    if (typeof web3 !=== 'undefined'){
         App.web3Provider = web3.currentProvider;
              web3 = new Web3(web3.currentProvider);
    } else {
              App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
              web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    /*
     * Replace me...
     */
  $.getJSON("AppInterface.json", function(manager) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Manager = TruffleContract(manager);
      // Connect provider to interact with contract
      App.contracts.Manager.setProvider(App.web3Provider);

      return App.render();
    });
  },

  render: function(){
    var managerInstance;
      var loader = $("#loader");
      var content = $("#content");
      loader.show();
      content.hide();

      web3.eth.getCoinbase(function(err,account){
        if(err === null)  {
            App.account = account;
            $("#accountAddress").html("Your Account: " + account);
        }
      })

      App.contracts.Manager.deployed().then(function(instance){
          managerInstance = instance;
          return managerInstance.isPersonRegistered();
      }).then(function(isReg){
          if(isReg === true){
              console.log("I am registered shit") 
              //              return 0;
              return managerInstance.numPersons;
          }
          else{
              managerInstance.isRegister(false)
              return managerInstance.numPersons;
          }
      }).then(function(personCount){
        var personRegistered = $("#personRegistered");
          personRegistered.empty();
          for(var i = 1; i <= numPersons; i++){
            managerInstance.person(i).then(function(person){
                var id = person[0];
                     // Render candidate Result
          var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
          candidatesResults.append(candidateTemplate);  
            })
          }
		loader.hide()
		content.show()
    }).catch(function(error){
	console.warn(error)
	})
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
