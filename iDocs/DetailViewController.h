//
//  DetailViewController.h
//  iDocs
//
//  Created by Francesco De Simone on 22/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"
@interface DetailViewController : UIViewController{
    
    Document *doc;
    IBOutlet UILabel *nome;
    IBOutlet UIImageView *imageView;
}
@property(nonatomic,retain) UILabel *nome;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) Document *doc;
@end
