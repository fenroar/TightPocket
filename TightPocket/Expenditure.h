//
//  Expenditure.h
//  TightPocket
//
//  Created by Peter Su on 03/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const kCategoryFood;
extern NSString * const kCategoryEntertainment;
extern NSString * const kCategoryTravel;
extern NSString * const kCategoryGroceries;
extern NSString * const kCategoryMedical;
extern NSString * const kCategoryOther;

extern NSString * const kExpenditureDateFormat;

@interface Expenditure : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * entryDate;
@property (nonatomic, retain) NSString * notes;

@end
