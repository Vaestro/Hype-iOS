#Hypelist2Point0 Readme

## Project Structure
### VIPER
Rather than MVC, this project uses a VIPER approach to organize the structure. A comprehensive introduction to VIPER can be found on [Medium](https://medium.com/brigade-engineering/brigades-experience-using-an-mvc-alternative-36ef1601a41f), but the gist is as follows:
![VIPER Illustration](https://d262ilb51hltx0.cloudfront.net/max/800/1*XovYPHm53nQ5H8tSeBx_IQ.png)

##### Wireframe
Initializes all classes, handles routing to other views. 
##### View
Displays info, detect user interaction. 
##### Presenter
Tells view what to display, handle events. 
##### Interactor
Performs business logic.
##### Data Manager
Retrieves and stores data. 
##### Service
Executes (network) requests for specific entities. 
##### Entity
Represents data.

### Modules
Following the VIPER organizational approach, the app is broken into multiple, independent interfaces:
##### Login Module
##### Facebook Picture Module
##### Number Verification Module
##### Event Discovery Module
##### Event Detail Module
##### Promotion Selection Module
##### Facebook Module
##### Parse Module

### Models (and Entities)
Subclasses of `PFObject`s serve as the base model for the app. However, these classes are intentionally abstracted away from much of the app in order to reduce complexity and dependence upon using Parse as a backend. The only VIPER components that interact with `PFObjects` and their subclasses are `DataManager` and `Service` components. All other VIPER components and objects "above" the level of `DataManager` should never directly interact with a `PFObject` or a subclass of one. Instead, these components and interactors are expected to utilize (the poorly named) `THLEntity` subclasses. 

Entities

### Interactions
The project seeks to abstract away as much information as possible so that each

