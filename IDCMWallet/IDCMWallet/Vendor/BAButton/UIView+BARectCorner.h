
/*
 
 *********************************************************************************
 *
 * 在使用BAKit的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ     : 可以添加ios开发技术群 479663605 在这里找到我(博爱1616【137361770】)
 * 微博    : 博爱1616
 * Email  : 137361770@qq.com
 * GitHub : https://github.com/boai
 * 博客    : http://boaihome.com
 
 *********************************************************************************
 
 */


#import <UIKit/UIKit.h>

/*!
 *  设置 viewRectCornerType 样式，
 *  注意：BAKit_ViewRectCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，
 */
typedef NS_ENUM(NSInteger, BAKit_ViewRectCornerType) {
    /*!
     *  设置下左角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomLeft = 0,
    /*!
     *  设置下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRight,
    /*!
     *  设置上左角 圆角半径
     */
    BAKit_ViewRectCornerTypeTopLeft,
    /*!
     *  设置下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeTopRight,
    /*!
     *  设置下左、下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomLeftAndBottomRight,
    /*!
     *  设置上左、上右角 圆角半径
     */
    BAKit_ViewRectCornerTypeTopLeftAndTopRight,
    /*!
     *  设置下左、上左角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomLeftAndTopLeft,
    /*!
     *  设置下右、上右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRightAndTopRight,
    /*!
     *  设置上左、上右、下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRightAndTopRightAndTopLeft,
    /*!
     *  设置下右、上右、下左角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRightAndTopRightAndBottomLeft,
    /*!
     *  设置全部四个角 圆角半径
     */
    BAKit_ViewRectCornerTypeAllCorners
};

@interface UIView (BARectCorner)

/**
 设置 viewRectCornerType 样式，注意：BAKit_ViewRectCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效
 */
@property (nonatomic, assign) BAKit_ViewRectCornerType ba_viewRectCornerType;

/**
 设置 view ：圆角，如果要全部设置四个角的圆角，可以直接用这个方法，必须要在设置 frame 之后，注意：如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效
 */
@property (nonatomic, assign) CGFloat ba_viewCornerRadius;

/**
  设置 view ：边框边线宽度
 */
@property(nonatomic, assign) CGFloat ba_viewBorderWidth;

/**
 设置 view ：边框边线颜色
 */
@property(nonatomic, strong) UIColor *ba_viewBorderColor;


/**
 快速切圆角
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 */
- (void)ba_view_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius;

/**
 快速切圆角，带边框、边框颜色

 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)ba_view_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;


@end
