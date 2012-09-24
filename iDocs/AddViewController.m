//
//  AddViewController.m
//  iDocs
//
//  Created by Francesco De Simone on 22/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import "AddViewController.h"
#import "Document.h"
#import "AppDelegate.h"
@interface AddViewController ()

@end

@implementation AddViewController
@synthesize imageView,image;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Document";
    
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self action:@selector(cancel_Clicked:)] ;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
											   target:self action:@selector(save_Clicked:)] ;
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) save_Clicked:(id)sender {
	
	AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//Create a Coffee Object.
	Document *doc =[[Document alloc] initWithPrimaryKey:0];
	doc.documentName = txtDocumentName.text;
	doc.documentImage  =  image;
	doc.isDirty = NO;
	doc.isDetailViewHydrated = YES;
	
	//Add the object
	[appDelegate addDocument:doc];
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) cancel_Clicked:(id)sender {
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
}
-(IBAction) takeImage:(id)sender{
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Scegli una foto" delegate:self cancelButtonTitle:@"Annnulla" destructiveButtonTitle:nil otherButtonTitles:@"Scegli",@"Scatta", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            NSLog(@"ipad");
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [popover presentPopoverFromRect:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 320,480) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            
            
            
            
        } else {
            [self presentModalViewController:imagePicker animated:YES];
        }
        NSLog(@" photo from library");
    } else if (buttonIndex == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            NSLog(@"ipad");
            
            
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [popover presentPopoverFromRect:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 320,480) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            
        } else {
            [self presentModalViewController:imagePicker animated:YES];
        }
        NSLog(@"take a photo ");
        
    }
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"called me");
    UIImage *takenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = takenImage;
    self.imageView.image = takenImage;
    
    
    [self dismissModalViewControllerAnimated:YES];
    
    
}



@end
