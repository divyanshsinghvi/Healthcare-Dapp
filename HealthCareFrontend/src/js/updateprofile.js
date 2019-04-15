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
    if (typeof web3 !== 'undefined'){
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
      web3.eth.getCoinbase(function(err,account){
        if(err === null)  {
            App.account = account;
            $("#accountAddress").html("Your Account: " + account);
        }
      })
$(document).ready(function() {
    $("#saveprofile").click(function(){


      App.contracts.Manager.deployed().then(function(instance){
          managerInstance = instance;
          return managerInstance.isPersonRegistered();
      }).then(function(regarr){
          isReg = regarr[0]
          if(isReg === true){
              console.log("I am registered shit") 
              console.log(regarr[1])
              $.getJSON("Person.json", function(person) {
                  console.log(person["abi"])
                  var personClass = web3.eth.contract(person["abi"]);
                  var personInstance = personClass.at(regarr[1]);
                  console.log(personInstance)
                  newName = $("#firstname").val() +"  " +  $("#secondname").val() 

                  personInstance.setName(newName, function(error){
                    if(!error){
                        console.log("Name set")
                    }
                   else
                     console.error(error);
                   })
                     role = $('input[name=role]:checked').val();
                  console.log(role)
                  if(role==='true'){
                    console.log("entered")
                    managerInstance.upgradeToDoctor();
                  }
 
              })
          }else{
              console.log("I am registering") 
              managerInstance.registerPerson(false)
          }
      }).catch(function(error){
	console.warn(error)
	})
    }); 
    });
  }
};



$(function() {
  $(window).load(function() {
    App.init();
  });
});
