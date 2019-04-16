# Healthcare-Dapp


## Introduction
A distributed application for health center to keep health care data for each patient which can be
securely shared among doctor (pharmacy and pathological test labs).


## System Configurations
We tested our application on a Ubuntu 16.04 LTS operating system with atleast 4GB of RAM. Numeraous dependencies which are required for our application are:
- npm (install using `sudo apt-get install npm`)
- truffle 
- ganache


## Implemented Features
- Participants of the Application: Persons and Doctors
- Any person having a valid Ethereum address can be a Person in our application. He/She can register as a patient as well as a doctor in the application. Currently we have not incorporated any mechanism to verify whether the person registering to the Application as a Doctor is a genuine one. We propose that such a mechanism can be incorporated as a future scope of the project.
- A person can keep a track of their medical reports and also provide access to their choice of doctors so that they can get a comprehensive view of the medical history of the patient.
- Any person(specifically a doctor) can view and/or modify the health report(s) of another person only if the owner of the Health Report has given access to the corresponding party.
- A person can request an appointment from the list of available slots of a doctor 7 days in advance. Once an appointment is completed, the slot can be re-used by other person for requesting appointment for the next week.


## Challenges Faced
One of the major challenge which we faced is the limitation on the size of the Contract's byte code. Currently, this limit is set to be 24KB, and any contract with byte code size greater than that gets rejected while compilation. This challenge set us back by a couple of days, as the whole business logic has to be split and refactored, incorporating interfaces and abstract contracts which are some of the best known methods to deal with such kind of a problem.


## Limitations of our project
- Currently, we have not implemented the features related to Pharmacy and Pathological test lab which we had planned initially. However, we do believe that these features can be implemented due to the degree of modifiability of our application.
- Presently, we have not taken into consideration the genuinity of the doctors. 

