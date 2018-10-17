//
//  OCDataHook.h
//  dxHook
//
//  Created by fcj on 2018/10/11.
//

#import <Foundation/Foundation.h>
@interface OCDataHook : NSObject
+(OCDataHook*)sharedInstance;
-(void)doHook;
@end
