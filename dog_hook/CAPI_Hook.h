//
//  CAPI_Hook.h
//  dxHook
//
//  Created by fcj on 2018/10/11.
//

#import <Foundation/Foundation.h>
@interface CAPIHook : NSObject
+(CAPIHook*)sharedInstance;
-(void)doHook;
@end
