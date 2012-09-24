//
//  RootViewController.m
//  iDocs
//
//  Created by Francesco De Simone on 22/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import "RootViewController.h"
#import "Document.h"
@interface RootViewController ()

@end

@implementation RootViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.documentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
	
	Document *doc = [appDelegate.documentArray objectAtIndex:indexPath.row];
	NSLog(@"prendo l'oggetto all' indice %d ",indexPath.row);
    
	cell.text = doc.documentName;
    
	cell.imageView.image = doc.documentImage;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Navigation logic -- create and push a new view controller
	
	if(dvController == nil)
		dvController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
	
	Document *doc = [appDelegate.documentArray objectAtIndex:indexPath.row];
	

	//[doc hydrateDetailViewData];
	
	dvController.doc = doc;
	
	[self.navigationController pushViewController:dvController animated:YES];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
											 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
											 target:self action:@selector(add_Clicked:)];
	
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = @"I Tuoi Documenti";
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		//Get the object to delete from the array.
		Document *coffeeObj = [appDelegate.documentArray objectAtIndex:indexPath.row];
		[appDelegate removeDocument:coffeeObj];
		
		//Delete the object from the table.
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
	
	//Do not let the user add if the app is in edit mode.
	if(editing)
		self.navigationItem.leftBarButtonItem.enabled = NO;
	else
		self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) add_Clicked:(id)sender {
	
	if(avController == nil)
		avController = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
	
	if(addNavigationController == nil)
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:avController];
	
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
}




@end
