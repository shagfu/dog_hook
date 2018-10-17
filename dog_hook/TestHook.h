//
//  TestHook.h
//  iTunesStoredHook
//
//  Created by fcj on 2017/5/10.
//
//

#import <Foundation/Foundation.h>
@interface TestHook : NSObject
+(TestHook*)sharedInstance;
-(void)dotest;

@end
