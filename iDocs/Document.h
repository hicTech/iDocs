//
//  Document.h
//  iDocs
//
//  Created by Francesco De Simone on 22/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface Document : NSObject{
    
    NSInteger documentID;
    NSString *documentName;
	UIImage *documentImage;
	
	//Intrnal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
    
}


@property (nonatomic, readonly) NSInteger documentID;
@property (nonatomic, copy) NSString *documentName;
@property (nonatomic, retain) UIImage *documentImage;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteDocument;
- (void) addDocument;
- (void) hydrateDetailViewData;
- (void) saveAllData;

@end
