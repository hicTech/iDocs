//
//  AddViewController.h
//  iDocs
//
//  Created by Francesco De Simone on 22/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import <UIKit/UIKit.h>

@class Document;
@interface AddViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    IBOutlet UITextField *txtDocumentName;
    IBOutlet UIImageView *imageView;
    UIImage *image;
}
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UIImage *image;
-(IBAction) takeImage:(id)sender;
@end
