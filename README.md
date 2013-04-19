WebService Samples
======



Showing how to connect and consume 3rd party RESTful API's in JSON or XML.
===

To make thinks easier I created a Connection Class (HKConnection). It uses a block that returns either an NSError or  NSData. Also you can pass the view you'd like the progress HUD(MBProgessHUD) to be displayed on.
````
- (id)initWithURL:(NSURL*)URL progressHudView:(UIView*)HUDdisplayView callback:(HKConnectionBlock)block;
- (id)initWithURL:(NSURL *)URL callback:(HKConnectionBlock)block;
````

1. Get locations and get the local weather 5 day forecast from WorlWeatherOnline.com. parse the JSON and display the results in a user friendly way.



2. Fun with the Dribbble API. Here I created a simple Dribbble Engine to get shots, comments and Player information. Results are shown in a tableView with custom cells. The shot's comments are viewable right in the tableView by adding  or deleting cells at the correct indexes (With animations). Shots can be enlarged/decreased using custom animations. 
Connecting is easy:

````
- (void)shotsForType:(ShotTypes)type page:(NSInteger)page;
- (void)commentsForShot:(Shots*)shot;
````
- There are 3 different "ShotTypes"  
  -  kShotTypePopular,
  -  kShotTypeDebuts,
  -  kShotsTypeEveryone

  
And DribbleAPI class returns one of three delegate methods:
````
- (void)dribleAPI:(DribbleAPI*)API didFailWithError:(NSError*)error;
- (void)driblleAPI:(DribbleAPI*)API didFinishGatheringShots:(NSArray*)shots;
- (void)dribbleAPI:(DribbleAPI*)API didFinishGatheringComments:(NSArray*)comments;
````


3. Rotten Tomatoes. Lists movies or DVD's based on user's input. Choice of category is given for: In theaters, Box office, Upcoming or Opening and listed in a tableView for easy viewing.
You can connect to Rotten Tomatoes like this:
````
- (void)rottenTomatoesForMovie:(MovieListType)movieType;
````
There are 4 different MovieListTypes.
  -  BoxOffice,
  -  InTheaters,
  -  Opening,
  -  Upcoming

And RottenTomatoes has only one delegate method right now (This will change in the next commit):
````
- (void)RottenTomatoes:(RottenTomatoes*)rottenTomatoes didFinishWithInformation:(NSDictionary*)RottenTomatoesData;
````


Thats it for now. It's still very much a work in progress...Any contributions and/or suggestions are always welcome.

If you plan on using any of this code for yourself please change the API Keys! I've temporaroly left mine in for demonstration purposes. 
===
