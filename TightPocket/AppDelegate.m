//
//  AppDelegate.m
//  TightPocket
//
//  Created by Peter Su on 02/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "AppDelegate.h"
#import "Expenditure.h"
#import "NSDate+Extensions.h"
#import "FNRViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setAppearance];
    [self clearOldData];
    MainViewController *initialViewController = (MainViewController *)self.window.rootViewController;
    if ([initialViewController isKindOfClass:[FNRViewController class]]) {
        initialViewController.managedObjectContext = self.managedObjectContext;
    } else {
        NSAssert(false, @"Failed to set managed object context for root view controller");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.fenroar.mobile.TightPocket" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TightPocket" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TightPocket.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Data management {

- (void)clearOldData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Expenditure"];
    
    // Delete records that are over a month old
    NSDate *startOfDate = [NSDate dayWithNoTime:[NSDate date]];
    NSDate *endOfDate = [NSDate subtractNumberOfDays:31 fromDate:startOfDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(entryDate < %@)", endOfDate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *oldExpenditures = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for (Expenditure *expenditure in oldExpenditures) {
            [self.managedObjectContext deleteObject:expenditure];
        }
        NSError *deleteError = nil;
        if ([self.managedObjectContext save:&deleteError] == NO) {
            NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
            abort();
        }
    } else {
        NSLog(@"Error fetching old data");
    }
}

- (void)setAppearance {
    UIColor *barTintColor = [UIColor FNRRed];
    UIColor *barBackgroundColor = [UIColor FNRWhite];
    UIColor *tabBarTintColor = [UIColor FNRRed];
    UIColor *tabBarBackgroundColor = [UIColor FNRWhite];
    
    NSDictionary *titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                           NSFontAttributeName : [UIFont systemFontOfSize:17.0f] };
    
    [[UINavigationBar appearance] setBarTintColor:barBackgroundColor];
    [[UINavigationBar appearance] setTintColor:barTintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIToolbar appearance] setBarTintColor:barBackgroundColor];
    [[UIToolbar appearance] setTintColor:barTintColor];
    [[UIToolbar appearance] setTranslucent:NO];
    
    [[UITabBar appearance] setBarTintColor:tabBarBackgroundColor];
    [[UITabBar appearance] setTintColor:tabBarTintColor];
    
    [[UIButton appearance] setTintColor:barTintColor];
    [[UIButton appearance] setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
}

@end
