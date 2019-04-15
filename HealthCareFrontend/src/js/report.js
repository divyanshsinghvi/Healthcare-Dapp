


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
      App.contracts.Manager.deployed().then(function(instance){
          managerInstance = instance;
          return managerInstance.isPersonRegistered();
      }).then(function(regarr){
          isReg = regarr[0]
          if(isReg === true){
              $.getJSON("Person.json", function(person) {
                  console.log(person["abi"])
                  var personClass = web3.eth.contract(person["abi"]);
                  var personInstance = personClass.at(regarr[1]);
                  console.log(personInstance)
                  var reports = new Array();

                  // personInstance.createNewHealthReport("weight:23","cold","crocin",function(error){
                  //       if(!error){
                  //           console.log("Your name is set to M")
                  //         }
                  //       else
                  //           console.log(error);

                  //    })
                  //    personInstance.createNewHealthReport("weight:25","fever","crocin",function(error){
                  //       if(!error){
                  //           console.log("Your name is set to M")
                  //         }
                  //       else
                  //           console.log(error);

                  //    })
                    personInstance.getLatestReport(function(error,myreport){
                      if(!error){
                          var i;
                          console.log(myreport)
                          for(i=0;i<myreport.length;i++){
                            reports.push(myreport[i])
                          }
                          var table = $("<table />");
                          table[0].border = "1";

                          var columnCount = reports[0].length;
                                 //Add the data rows.
                          for (var i = 1; i < myreport.length; i++) {
                              row = $(table[0].insertRow(-1));
                          for (var j = 0; j < columnCount; j++) {
                            var cell = $("<td />");
                            cell.html(myreport[i][j]);
                            row.append(cell);
                        }
                    }
             
                    var dvTable = $("#myreport");
                    dvTable.html("");
                    dvTable.append(table);
                      }
                      else{
                          console.error(error);
                      }
                      return reports;
                    })
                    
                   
              })
          }else{
              console.log("I am registering") 
              managerInstance.registerPerson(false)
          }
      }).catch(function(error){
  console.warn(error)
  })
     
    });
  }
};



$(function() {
  $(window).load(function() {
    App.init();
  });
});