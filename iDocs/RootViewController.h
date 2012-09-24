//
//  RootViewController.h
//  iDocs
//
//  Created by Francesco De Simone on 22/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddViewController.h"
#import "DetailViewController.h"
@interface RootViewController : UITableViewController{
	
	AppDelegate *appDelegate;
	AddViewController *avController;
	DetailViewController *dvController;
	UINavigationController *addNavigationController;
}

@end
