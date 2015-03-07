#import <UIKit/UIKit.h>
// 数值
UIKIT_EXTERN CGFloat const HMScreenMaxWH;
UIKIT_EXTERN CGFloat const HMScreenMinWH;

// 通知
/** 排序改变的通知 */
UIKIT_EXTERN NSString *const HMSortDidChangeNotification;
/** 通过这个key可以取出当前的排序模型 */
UIKIT_EXTERN NSString *const HMCurrentSortKey;

/** 类别改变的通知 */
UIKIT_EXTERN NSString *const HMCategoryDidChangeNotification;
/** 通过这个key可以取出当前的类别模型 */
UIKIT_EXTERN NSString *const HMCurrentCategoryKey;
/** 通过这个key可以取出当前子类别的索引 */
UIKIT_EXTERN NSString *const HMCurrentSubcategoryIndexKey;

/** 城市改变的通知 */
UIKIT_EXTERN NSString *const HMCityDidChangeNotification;
/** 通过这个key可以取出当前的城市模型 */
UIKIT_EXTERN NSString *const HMCurrentCityKey;

/** 区域改变的通知 */
UIKIT_EXTERN NSString *const HMDistrictDidChangeNotification;
/** 通过这个key可以取出当前的区域模型 */
UIKIT_EXTERN NSString *const HMCurrentDistrictKey;
/** 通过这个key可以取出当前子区域的索引 */
UIKIT_EXTERN NSString *const HMCurrentSubdistrictIndexKey;

/** cell遮盖点击的通知 */
UIKIT_EXTERN NSString *const HMCellCoverDidClickNotification;