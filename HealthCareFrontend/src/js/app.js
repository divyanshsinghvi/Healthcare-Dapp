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
            console.log(account+"account")
        }
      })

      App.contracts.Manager.deployed().then(function(instance){
          managerInstance = instance;
          return managerInstance.isPersonRegistered();
      }).then(function(regarr){
          isReg = regarr[0]
          if(isReg === true){
              console.log(regarr[1]+"regarr")
              $.getJSON("PersonContract.json", function(person) {
//                  console.log(person["abi"])
                  var personClass = web3.eth.contract(person["abi"]);
                  console.log(regarr[1])
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

        managerInstance.getListOfDoctors().then(function(docs){  console.log(docs)
            
            $.getJSON("PersonContract.json", function(person) {
            for(let i=0;i<parseInt(docs[0].toString());i++)
                {
                    var d = docs[1];
                  var doctorClass = web3.eth.contract(person["abi"]);
                var doctorInstance = doctorClass.at(docs[1][i]);
                  doctorInstance.getName(function(error, myname){
                    if(!error){
                console.log(d[i],myname,doctorInstance)    
                        $(document).ready(function(){
                            $("#doctorL").append('<li><a href="#">'+myname+'</a><span  style=display:none>'+d[i]+'</span></li>') 
                        })
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


function createUUID() {
     function s4() {
         return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
     }

     return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
 }



$(function() {
  function bin2String(array) {
  return String.fromCharCode.apply(String, array);
}

  window.onclick = function (e) {
      
        console.log("requestAppointment");
      if (e.target.localName == 'a') {
        console.log($(e.target.parentNode).find("span").html())
          doctoraddress = $(e.target.parentNode).find("span").html()
          valu = $("#myInput").val()
          if(valu == ''){
            valu = 1;
          }
        $.getJSON("PersonContract.json", function(person) {
            var doctorClass = web3.eth.contract(person["abi"]);
            var doctorInstance = doctorClass.at(doctoraddress);
            doctorInstance.getUID(function(error,uid){
              if(!error){
                console.log(uid);
                App.contracts.Manager.deployed().then(function(instance){
                  managerInstance = instance;
                  req = createUUID()
                  console.log("request id" + req)
                  managerInstance.requestAppointment(uid, valu, req)
                  //doctorInstance.getAppointmentsData(function(err,data){console.log(data)})
                })
              }else{
                console.log(error);
              }
            })
        })
         

    }else if(e.target.id == 'getAppointmentForDoctor'){
       App.contracts.Manager.deployed().then(function(instance){
          managerInstance = instance;
          return managerInstance.isPersonRegistered();
      }).then(function(regarr){
        $.getJSON("PersonContract.json", function(person) {
          var personClass = web3.eth.contract(person["abi"]);
          var personInstance = personClass.at(regarr[1]);
          console.log("Data for person is "+personInstance);
          personInstance.getDoctorFlag(function(err,flag){
            if(!err){
              console.log("Am I a doctor ??" + flag)
              if(flag===true){
                personInstance.getAppointmentsData(function(err,data){
                    if(!err){
                    for(j=0;j<data[0].length;j++){
                        console.log(bin2String(data[0][j]))
                    }
                        //                    managerInstance.completeAppointment(bin2String(data[0][0]))
                    console.log(data)
                  }
                  else
                    console.log(err)
                })
              }
            }else{
              console.log(err)
            }
          })
       }) 

    })

    }
  }
  $(window).load(function() {
    App.init();
  });
});
