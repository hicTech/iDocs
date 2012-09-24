//
//  AppDelegate.h
//  iDocs
//
//  Created by Francesco De Simone on 21/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import <UIKit/UIKit.h>
@class Document;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	NSMutableArray *documentArray;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSMutableArray *documentArray;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) removeDocument:(Document *)doc;
- (void) addDocument:(Document *)doc;

@end
