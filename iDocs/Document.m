//
//  Document.m
//  iDocs
//
//  Created by Francesco De Simone on 22/09/12.
//  Copyright (c) 2012 Francesco De Simone (www.fdesimone.com). All rights reserved.
//

#import "Document.h"
#import "AppDelegate.h"
#import <sqlite3.h>
static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;
@implementation Document
@synthesize documentID,documentImage,documentName,isDetailViewHydrated,isDirty;



+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select documentID,documentName,documentImage from Document";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Document *doc = [[Document alloc] initWithPrimaryKey:primaryKey];
                
				doc.documentName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
                NSData *dataForCachedImage = [[NSData alloc] initWithBytes:sqlite3_column_blob(selectstmt, 2) length: sqlite3_column_bytes(selectstmt, 2)];
                
                UIImage *letta =[UIImage  imageWithData:dataForCachedImage];
                
                if(letta!=nil) NSLog(@"immagine letta correttamente");
               
                doc.documentImage = letta;
				doc.isDirty = NO;
				
				
				[appDelegate.documentArray addObject:doc];
				
			}
		}
	}
	else
		sqlite3_close(database); 
}

+ (void) finalizeStatements {
	
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (addStmt) sqlite3_finalize(addStmt);
	if (detailStmt) sqlite3_finalize(detailStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
}

- (id) initWithPrimaryKey:(NSInteger) pk {
	
	
	documentID = pk;
	
	documentImage = [[UIImage alloc] init];
	isDetailViewHydrated = NO;
	
	return self;
}

- (void) deleteDocument {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from Document where documentID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, documentID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt))
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

- (void) addDocument {
	
	if(addStmt == nil) {
		const char *sql = "insert into Document(documentName,documentImage) Values(?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
    if(self.documentImage!=nil)NSLog(@"sto salvando nel database un immagina");
    
	NSData *imgData = UIImagePNGRepresentation(self.documentImage);
	sqlite3_bind_text(addStmt, 1, [documentName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_blob(addStmt, 2, [imgData bytes], [imgData length], NULL);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		documentID = sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) hydrateDetailViewData {
	
	//If the detail view is hydrated then do not get it from the database.
	if(isDetailViewHydrated) return;
	
	if(detailStmt == nil) {
		const char *sql = "Select  documentImage from Document Where documentID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_int(detailStmt, 1, documentID);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		
		
		
		NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(detailStmt, 1) length:sqlite3_column_bytes(detailStmt, 1)];
		
		if(data == nil)
			NSLog(@"No image found.");
		else
			self.documentImage = [UIImage imageWithData:data];
		
	}
	else
		NSAssert1(0, @"Error while getting the price of coffee. '%s'", sqlite3_errmsg(database));
	
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
	
	//Set isDetailViewHydrated as YES, so we do not get it again from the database.
	isDetailViewHydrated = YES;
}

- (void) saveAllData {
	
	if(isDirty) {
		
		if(updateStmt == nil) {
			const char *sql = "update Document Set documentName = ?, documentImage = ? Where documentID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(updateStmt, 1, [documentName UTF8String], -1, SQLITE_TRANSIENT);
		
		
		NSData *imgData = UIImagePNGRepresentation(self.documentImage);
		
		int returnValue = -1;
		if(self.documentImage != nil)
			returnValue = sqlite3_bind_blob(updateStmt, 2, [imgData bytes], [imgData length], NULL);
		else
			returnValue = sqlite3_bind_blob(updateStmt, 2, nil, -1, NULL);
		
		sqlite3_bind_int(updateStmt, 2, documentID);
		
		if(returnValue != SQLITE_OK)
			NSLog(@"Not OK!!!");
		
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
		
		isDirty = NO;
	}
	
	
	
	isDetailViewHydrated = NO;
}

- (void)setDocumentName:(NSString *)newValue {
	
	self.isDirty = YES;
	
	documentName = [newValue copy];
}



- (void)setDocumentImage:(UIImage *)theDocumentImage {
	
	self.isDirty = YES;

	documentImage = theDocumentImage;
}



//First open a blob connection using sqlite3_blob_open
//Using the above function will give you sqlite3_blob
//Read the image by passing sqlite3_blob struct in sqlite3_blob_read


@end
