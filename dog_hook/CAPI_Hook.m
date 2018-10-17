//
//  CAPI_Hook.c
//  dxHook
//
//  Created by fcj on 2018/10/11.
//

#include "CAPI_Hook.h"
#include <substrate.h>
#include <mach-o/dyld.h>
#include <objc/objc-runtime.h>
#include <zlib.h>
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>
#import <sys/stat.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <sys/socket.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
static CAPIHook* m_TestHook;
@implementation CAPIHook : NSObject
+(CAPIHook*)sharedInstance
{
    
    
    if(m_TestHook ==NULL){
        m_TestHook=[[CAPIHook alloc] init];
    }
    return  m_TestHook;
}
MSHook(const char*, _dyld_get_image_name, uint32_t image_index)
{
    
    const char* strResutl= __dyld_get_image_name(image_index);
    if(strstr(strResutl, "Substrate"))
    {
        return "/usr/lib/libsqlite3.dylib";
    }else{
        return strResutl;
    }
}
MSHook(FILE*, fopen, const char* path,const char* mode)
{
    NSLog(@"---------fopen   path==%s",path);
    return _fopen(path,mode);
}
MSHook(int, strlen, const char* str)
{
    NSLog(@"-----**********----strlen   str==%s",str);
    return _strlen(str);
}
MSHook(const char*, strstr, const char* big,const char* little)
{
    NSLog(@"-----**********----strstr   str==%s",big);
    return _strstr(big,little);
}
MSHook(int, deflate, z_streamp strm, int flush)
{
    const char* data= (const char*)(strm->next_in);
    NSLog(@"-----**********----avail len ==%d  ",strm->avail_in);
    NSLog(@"-----**********----deflate ==%s  ",data);
    
    NSArray *syms = [NSThread  callStackSymbols];
    NSLog(@"callStackSymbols ==%@ ",syms);
    return _deflate(strm,flush);
}
MSHook(int, inflate, z_streamp strm, int flush)
{
    const char* data= (const char*)(strm->next_in);
    //NSLog(@"-----**********----inflate ==%s  ",data);
    return _deflate(strm,flush);
}
MSHook(char*, getenv, const char* str)
{
    NSLog(@"-----**********----getenv ==%s  ",str);
    return _getenv(str);
}
MSHook(char*, strcpy, char *dest,char* src)
{
    NSLog(@"-----**********----strcpy ==%s  ",src);
    return _strcpy(dest,src);
}
MSHook(int, dladdr, const void *method , Dl_info *method_info)
{

    int ret= _dladdr(method,method_info);
    NSLog(@"-----**********----dladdr ==%s   %s   ",method_info->dli_sname ,method_info->dli_sname);
    return ret;
}
MSHook(int, uname, struct utsname * unameinfo)
{
    int ret= _uname(unameinfo);
    NSLog(@"-----**********----uname ==%s  ",unameinfo->machine);
    NSLog(@"-----**********----uname ==%s  ",unameinfo->version);
    return ret;
}
MSHook(int, stat, const char *path , struct stat *stat_info )
{
    return _stat(path,stat_info);
}
MSHook(int, lstat, const char *path , struct stat *stat_info )
{
    NSLog(@"-----**********----lstat ==%s  ",path);
     return _lstat(path,stat_info);
}
MSHook(int, sysctl, int *name,u_int namelen,void *oldp,size_t *oldlenp,const void *newp,size_t newlen)
{
    if(name[0]==CTL_KERN)
    {
        if(name[1]==KERN_PROC)
        {
            //NSLog(@"-----**********----sysctl KERN_PROC");
            
        }else if(name[1]==KERN_BOOTTIME)
        {
            NSLog(@"-----**********----sysctl KERN_BOOTTIME");
        }else
        {
            
        }
    }else if(name[0]==CTL_HW)
    {
        if(name[1]==HW_MEMSIZE)
        {
            NSLog(@"-----**********----sysctl HW_MEMSIZE");
        }
    }else if(name[0]==CTL_NET)
    {
        NSLog(@"-----**********----sysctl CTL_NET");
    }
    return _sysctl(name,namelen,oldp,oldlenp,newp,newlen);
}
MSHook(int, sysctlbyname, const char *name, void *oldp, size_t *oldlenp,
       const void *newp, size_t newlen)
{
    NSLog(@"-----**********----_sysctlbyname ==%s ",name);
    return _sysctlbyname(name,oldp,oldlenp,newp,newlen);
}
MSHook(unsigned char *, CC_MD5, const void *data, CC_LONG len, unsigned char *md)
{
    NSLog(@"-----**********----CC_MD5 ==%s ",data);
    return _CC_MD5(data,len,md);
}
MSHook(CFDictionaryRef, CFNetworkCopySystemProxySettings)
{

    CFDictionaryRef ret= _CFNetworkCopySystemProxySettings();
     NSLog(@"-----**********----CFNetworkCopySystemProxySettings ==%@ ",ret);
    return ret;
    
}
-(void)doHook
{
    //MSHookFunction(inflate, MSHake(inflate));
    //MSHookFunction(fopen, MSHake(fopen));
    //MSHookFunction(strlen, MSHake(strlen));
    //MSHookFunction(strstr, MSHake(strstr));
    //MSHookFunction(strcpy, MSHake(strcpy));
    //MSHookFunction(getenv, MSHake(getenv));
    MSHookFunction(_dyld_get_image_name, MSHake(_dyld_get_image_name));
    MSHookFunction(deflate, MSHake(deflate));
    MSHookFunction(dladdr, MSHake(dladdr));
    MSHookFunction(uname, MSHake(uname));
    MSHookFunction(stat, MSHake(stat));
    MSHookFunction(lstat, MSHake(lstat));
    MSHookFunction(sysctl, MSHake(sysctl));
    MSHookFunction(sysctlbyname, MSHake(sysctlbyname));
    MSHookFunction(CC_MD5, MSHake(CC_MD5));
    MSHookFunction(CFNetworkCopySystemProxySettings, MSHake(CFNetworkCopySystemProxySettings));
}

@end
