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
                  //import("search.js").then(function)
                  //countries=[personInstance]
                  personInstance.getName(function(error, myname){
                    if(!error){
                        $("#myname").html( myname);
                        }
                   else
                     console.error(error);
                   }) 
              })

        managerInstance.getListOfDoctors().then(function(docs){  console.log(docs[0].toString())
            
            $.getJSON("Person.json", function(person) {
            for(i=0;i<parseInt(docs[0].toString());i++)
            {
                  var doctorClass = web3.eth.contract(person["abi"]);
                  var doctorInstance = doctorClass.at(docs[1][i]);
                  doctorInstance.getName(function(error, myname){
                    if(!error){
                console.log(docs[1][i],myname)    
                        $(document).ready(function(){
                            $("#doctorL").append('<li><a href="#">'+myname+'</a><span  style=display:none>'+doctorInstance["address"]+'</span></li>') 
                        })
                        $("#myname").html( myname);
                        }
                   else
                     console.error(error);
                   }) 
            }
        })});
          }else{
              console.log("I am registering") 
              managerInstance.registerPerson(false)
          }
      }).catch(function(error){
	console.warn(error)
	})
  }
};



$(function() {
  
  window.onclick = function (e) {
    if (e.target.localName == 'a') {
        console.log($(e.target.parentNode).find("span").html())
        doctoraddress = $(e.target.parentNode).find("span").html()
        $.getJSON("Person.json", function(person) {
            var doctorClass = web3.eth.contract(person["abi"]);
            var doctorInstance = doctorClass.at(doctoraddress);
            doctorInstance.getUID(function(error,uid){
              if(!error){
                console.log(uid);
                App.contracts.Manager.deployed().then(function(instance){
                  managerInstance = instance;
                  managerInstance.requestAppointment(uid, 1, "2")
                  //doctorInstance.getAppointmentsData(function(err,data){console.log(data)})
                })
              }else{
                console.log(error);
              }
            })
            


        })
         

    }
  }
  $(window).load(function() {
    App.init();
  });
});
