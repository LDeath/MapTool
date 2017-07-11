//
//  MAFMapTool.h
//  MapHelp
//
//  Created by 高赛 on 2017/7/7.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^MapLocationBlock)(BOOL isSuccess, NSString *latitude, NSString *longitude, BOOL isHaveInfo, NSString *address, NSString *name, NSString * cityCode, NSString *adCode);
typedef void (^MapSearchBlock)(NSArray *dataArr, NSInteger page);
typedef void (^MapOfflineUpdateBlock)(BOOL isUpdate);
//0下载成功 1取消 2发生错误 3下载过程中 4全部下载完成
typedef void (^MapOfflineDownloadBlock)(int status);

@interface MAFMapTool : NSObject

/**
 单词定位回调block
 */
@property (nonatomic, copy) MapLocationBlock signleLocationBlock;
/**
 持续定位回调block
 */
@property (nonatomic, copy) MapLocationBlock alwaysLocationBlock;
/**
 关键字检索回调block
 */
@property (nonatomic, copy) MapSearchBlock keyWordSearchBlock;
/**
 周边搜索回调block
 */
@property (nonatomic, copy) MapSearchBlock poiSearchBlock;
/**
 离线地图是否需要更新block
 */
@property (nonatomic, copy) MapOfflineUpdateBlock offlineUpdateBlock;
/**
 离线地图下载状态回调block
 */
@property (nonatomic, copy) MapOfflineDownloadBlock offlineDownloadBlock;

//+ (instancetype)sharedInstance;
/**
 初始化地图sdk
 */
- (void)initMapWithKey:(NSString *)key;
/**
 根据frame获取地图视图
 */
- (UIView *)getMAMapViewWithFrame:(CGRect )frame;
/**
 需要显示大头针
 */
- (void)needShowAnnotationWithIsNeedSearch:(BOOL)isNeedSearch;
/**
 关键字检索
 */
- (void)searchKeyWord:(NSString *)keyWord andPage:(NSInteger )page;
/**
 根据大头针的位置检索
 */
- (void)searchPOIWithPage:(NSInteger )page;
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
- (void)singleLocationWithLocationBlock:(MapLocationBlock )locationBlock;
/**
 开启持续定位
 */
- (void)startAlwaysLocationWithLocationBlock:(MapLocationBlock )locationBlock;
/**
 停止持续定位
 */
- (void)stopAlwaysLocation;

@end
