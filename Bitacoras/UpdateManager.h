//
//  UpdateManager.h
//  ReactiveLearning
//
//  Created by Stephen L. McMahon on 8/4/13.
//
//  implmementation: https://gist.github.com/slmcmahon/6152160

#import <Foundation/Foundation.h>

@interface UpdateManager : NSObject
@property (nonatomic, copy) NSString *pListUrl;
@property (nonatomic, copy) NSString *versionUrl;
@property (nonatomic, copy) NSString *currentServerVersion;

+ (UpdateManager *)sharedManager;
- (void)checkForUpdates;
- (void)performUpdate;
@end
