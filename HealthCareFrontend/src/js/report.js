


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
              $.getJSON("HealthReportContract.json", function(person) {
                  console.log(person["abi"])
                  var personClass = web3.eth.contract(person["abi"]);
                  var personInstance = personClass.at(regarr[2]);
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
                            reports.push(myreport)
                          }
                          var table = $("<table />");
                          table[0].border = "1";

                          var columnCount = reports[0].length;
                          console.log("No of words is " + columnCount)
                                 //Add the data rows.
                          row = $(table[0].insertRow(-1));
                          for (var i = 0; i < myreport.length; i++) {
                                var cell = $("<td />");
                                cell.html(myreport[i]);
                                console.log("This is element of my report " + myreport[i] )
                                row.append(cell);
                        
                          }
             
                    var dvTable = $("#myreport");
                    dvTable.html("");
                    dvTable.append(table);

                    $(document).ready(function(){
                      var htmlreport = "";
                       for (var i = 0; i < myreport.length; i++) {
                                var cell = "<h6 >";
                                cell += myreport[i];
                                cell += "</h6>"
                                htmlreport+=cell
                                console.log("This is element of my report " + myreport[i] )            
                          }
                      $("#reports").append('<div class="card text-white bg-info mb-3" style="max-width: 18rem;"><div class="card-body">'+htmlreport+'</div></div>' )
                    })
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
