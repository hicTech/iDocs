//
//  AppDelegate.m
//  iDocs
//
//  Created by Francesco De Simone on 21/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import "AppDelegate.h"
#import "Document.h"
@implementation AppDelegate
@synthesize documentArray,navigationController,window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Copy database to the user's phone if needed.
	[self copyDatabaseIfNeeded];
	
	//Initialize the coffee array.
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.documentArray = tempArray;
	
	
	//Once the db is copied, get the initial data to display on the screen.
	[Document getInitialDataToDisplay:[self getDBPath]];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Sono tornata attiva");
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    //Save all the dirty coffee objects and free memory.
	[self.documentArray makeObjectsPerformSelector:@selector(saveAllData)];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
     NSLog(@"entro in background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"entro in foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"divento attiva");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save data if appropriate
	
	//Save all the dirty coffee objects and free memory.
	[self.documentArray makeObjectsPerformSelector:@selector(saveAllData)];
	
	[Document finalizeStatements];
}




- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SQL.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SQL.sqlite"];
}

-(void) removeDocument:(Document *)docObj{
    
    [docObj deleteDocument];
    
    [documentArray removeObject:docObj];
    
}


-(void) addDocument:(Document *)doc{
    [doc addDocument];
    
    [documentArray addObject:doc];
}

@end
