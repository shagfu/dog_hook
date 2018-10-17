//
//  TestHook.m
//  iTunesStoredHook
//
//  Created by fcj on 2017/5/10.
//
//
#define MACH_PORT_NAME "kr.joy.AppStore"
#include <mach-o/dyld.h>
#include <substrate.h>
#include <sys/mman.h>
#import <objc/objc-runtime.h>
#import "TestHook.h"
#include "OCDataHook.h"
#include "CAPI_Hook.h"
@implementation TestHook
+(TestHook*)sharedInstance
{

    static TestHook* m_TestHook;
    if(m_TestHook ==NULL){
        m_TestHook=[[TestHook alloc] init];
    }
    return  m_TestHook;
}
- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
        
    }
    [defs synchronize];
}
-(void)dotest
{
    
    NSLog(@"---------------InitFakeDevice  InitFakeDevice");
    [self resetDefaults];
    //cleankeychain();
    [[OCDataHook sharedInstance] doHook];
    [[CAPIHook sharedInstance] doHook];

}

@end
