//
//  MAFMapTool.h
//  MapHelp
//
//  Created by 高赛 on 2017/7/7.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MAFMapTool : NSObject

@property (nonatomic, strong) AMapLocationManager *locationManager;

+ (instancetype)sharedInstance;

/**
 初始化地图sdk
 */
- (void)initMapWithKey:(NSString *)key;
/**
 根据frame获取地图视图
 */
- (MAMapView *)getMAMapViewWithFrame:(CGRect )frame;
/**
 需要显示大头针
 */
- (void)needShowAnnotationWithIsNeedSearch:(BOOL)isNeedSearch;
/**
 关键字检索
 */
- (void)searchKeyWord:(NSString *)keyWord andPage:(NSInteger )page;
/**
 初始化离线地图plist数据
 */
- (void)setOfflineMap;
/**
 监测新版本。注意：如果有新版本，会重建所有的数据，包括provinces、municipalities、nationWide、cities，
 */
- (void)checkOfflineMap;
/**
 下载全国概要离线地图
 */
- (void)downloadNationWideOfflineMap;
/**
 根据城市id下载对应城市离线地图
 */
- (void)downloadCityOfflineMapWithCityCode:(NSString *)cityCode;
/**
 暂停全国概要图下载
 */
- (void)pauseWithNationWide;
/**
 根据城市编号暂停下载
 */
- (void)pauseWithCityCode:(NSString *)cityCode;
/**
 删除全国概要图离线地图数据
 */
- (void)deleteNationWide;
/**
 根据城市id删除对应城市离线地图数据
 */
- (void)deleteWithCityCode:(NSString *)cityCode;
/**
 取消全部下载
 */
- (void)cancleAllDownload;
/**
 初始化定位
 */
- (void)initLocationMap;
/**
 发起单次定位
 */
- (void)singleLocation;
/**
 开启持续定位
 */
- (void)startAlwaysLocation;
/**
 停止持续定位
 */
- (void)stopAlwaysLocation;

@end
