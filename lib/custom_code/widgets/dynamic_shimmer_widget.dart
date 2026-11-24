// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';

/// DynamicShimmerWidget A versatile, high-performance shimmer loader for
/// Flutter & FlutterFlow.
///
/// Supports Row or Column layout, customizable card presets ('productCard',
/// 'listItem', 'banner', 'box'), continuous looping animation, and custom
/// dimensions.
class DynamicShimmerWidget extends StatefulWidget {
  const DynamicShimmerWidget({
    super.key,
    this.width,
    this.height,
    this.isRow = true,
    this.itemCount = 4,
    this.itemWidth,
    this.itemHeight,
    this.spacing = 12.0,
    this.borderRadius = 12.0,
    this.shimmerType =
        'productCard', // 'productCard', 'listItem', 'banner', 'box'
    this.baseColor,
    this.highlightColor,
    this.scrollable = true,
  });

  final double? width;
  final double? height;
  final bool isRow;
  final int itemCount;
  final double? itemWidth;
  final double? itemHeight;
  final double spacing;
  final double borderRadius;
  final String shimmerType;
  final Color? baseColor;
  final Color? highlightColor;
  final bool scrollable;

  @override
  State<DynamicShimmerWidget> createState() => _DynamicShimmerWidgetState();
}

class _DynamicShimmerWidgetState extends State<DynamicShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = widget.baseColor ?? const Color(0xFFE9EBEF);
    final effectiveHighlightColor =
        widget.highlightColor ?? const Color(0xFFF8F9FA);

    final Widget shimmerList = _buildItemList(context, effectiveBaseColor);

    final int count = widget.itemCount <= 0 ? 1 : widget.itemCount;
    final double defaultItemWidth =
        widget.shimmerType.toLowerCase() == 'banner' ? 220.0 : 150.0;
    final double cardWidth = widget.itemWidth ?? defaultItemWidth;

    // If multiple horizontal items are requested, unconstrain width if it was restricted to a single card width
    final double? effectiveWidth = (widget.isRow &&
            count > 1 &&
            widget.width != null &&
            widget.width! <= cardWidth)
        ? null
        : (widget.width != null && widget.width!.isFinite
            ? widget.width
            : null);

    final double? effectiveHeight =
        (widget.height != null && widget.height!.isFinite)
            ? widget.height
            : null;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double slide = (_controller.value * 3.0) - 1.0;
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1.5 + slide, -0.2),
                end: Alignment(0.5 + slide, 0.2),
                stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                colors: [
                  effectiveBaseColor,
                  effectiveBaseColor,
                  effectiveHighlightColor,
                  effectiveBaseColor,
                  effectiveBaseColor,
                ],
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: shimmerList,
      ),
    );
  }

  Widget _buildItemList(BuildContext context, Color skeletonColor) {
    final int count = widget.itemCount <= 0 ? 1 : widget.itemCount;
    final double defaultSpacing = widget.isRow ? 16.0 : 12.0;
    final double effectiveSpacing = count > 1
        ? (widget.spacing > 0 ? widget.spacing : defaultSpacing)
        : 0.0;

    final String type = widget.shimmerType.toLowerCase();
    if (count == 1 ||
        type == 'cart' ||
        type == 'cartpage' ||
        type == 'cartscreen' ||
        type == 'detail' ||
        type == 'productdetail' ||
        type == 'product_detail' ||
        type == 'productdetailcard') {
      return _buildSingleItem(context, skeletonColor);
    }

    if (widget.isRow) {
      // Horizontal Layout (Row)
      if (widget.scrollable) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < count; i++) ...[
                if (i > 0 && effectiveSpacing > 0)
                  SizedBox(width: effectiveSpacing),
                _buildSingleItem(context, skeletonColor),
              ],
            ],
          ),
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (int i = 0; i < count; i++) ...[
              if (i > 0 && effectiveSpacing > 0)
                SizedBox(width: effectiveSpacing),
              Expanded(
                child: _buildSingleItem(context, skeletonColor),
              ),
            ],
          ],
        );
      }
    } else {
      // Vertical Layout (Column)
      if (widget.scrollable) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < count; i++) ...[
                if (i > 0 && effectiveSpacing > 0)
                  SizedBox(height: effectiveSpacing),
                _buildSingleItem(context, skeletonColor),
              ],
            ],
          ),
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < count; i++) ...[
              if (i > 0 && effectiveSpacing > 0)
                SizedBox(height: effectiveSpacing),
              _buildSingleItem(context, skeletonColor),
            ],
          ],
        );
      }
    }
  }

  Widget _buildSingleItem(BuildContext context, Color skeletonColor) {
    switch (widget.shimmerType.toLowerCase()) {
      case 'listitem':
        return _buildListItem(context, skeletonColor);
      case 'banner':
        return _buildBanner(context, skeletonColor);
      case 'detail':
      case 'productdetail':
      case 'product_detail':
      case 'productdetailcard':
        return _buildDetail(context, skeletonColor);
      case 'cart':
      case 'cartpage':
      case 'cartscreen':
        return _buildCart(context, skeletonColor);
      case 'cartitem':
      case 'cart_item':
        return _buildCartItem(context, skeletonColor);
      case 'box':
        return _buildBox(context, skeletonColor);
      case 'productcard':
      default:
        return _buildProductCard(context, skeletonColor);
    }
  }

  // 1. Product Card Skeleton (Ideal for HomePage & Search grid/horizontal lists)
  Widget _buildProductCard(BuildContext context, Color skeletonColor) {
    final double w = widget.itemWidth ?? 150.0;
    final double h = widget.itemHeight ?? 220.0;
    final double radius = widget.borderRadius;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: const Color(0xFFE2E6EA),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image box
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFDFE2E6),
                borderRadius:
                    BorderRadius.circular(radius > 2 ? radius - 2 : 4),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          // Title line 1
          Container(
            width: w * 0.75,
            height: 12.0,
            decoration: BoxDecoration(
              color: const Color(0xFFDFE2E6),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 6.0),
          // Title line 2
          Container(
            width: w * 0.45,
            height: 10.0,
            decoration: BoxDecoration(
              color: const Color(0xFFDFE2E6),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const Spacer(),
          // Bottom row: Price + Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 45.0,
                height: 14.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFDFE2E6),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              Container(
                width: 26.0,
                height: 26.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFDFE2E6),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. List Item Skeleton (Ideal for Chat Users list, Cart, Orders, Notifications)
  Widget _buildListItem(BuildContext context, Color skeletonColor) {
    final double w = widget.itemWidth ?? double.infinity;
    final double h = widget.itemHeight ?? 74.0;
    final double radius = widget.borderRadius;

    return Container(
      width: w,
      height: h,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: const Color(0xFFE2E6EA),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Circle Avatar placeholder
          Container(
            width: 48.0,
            height: 48.0,
            decoration: const BoxDecoration(
              color: Color(0xFFDFE2E6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14.0),
          // Middle Text lines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 130.0,
                  height: 13.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFE2E6),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 11.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFE2E6),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          // Trailing timestamp / pill
          Container(
            width: 38.0,
            height: 10.0,
            decoration: BoxDecoration(
              color: const Color(0xFFDFE2E6),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Banner Card Skeleton (Ideal for HomePage Promo Banner & Farm Cards)
  Widget _buildBanner(BuildContext context, Color skeletonColor) {
    final double w = widget.itemWidth ?? double.infinity;
    final double h = widget.itemHeight ?? 160.0;
    final double radius = widget.borderRadius;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 160.0,
            height: 16.0,
            decoration: BoxDecoration(
              color: const Color(0xFFDFE2E6),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 90.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: const Color(0xFFDFE2E6),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(BuildContext context, Color skeletonColor) {
    final double? w = widget.itemWidth ?? widget.width;
    final double? h = widget.itemHeight ?? widget.height;
    final double radius = widget.borderRadius;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    final Widget columnContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Top Hero Image with Back and Favorite circular buttons
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 244.0,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(radius > 0 ? radius : 8.0),
              ),
            ),
            Positioned(
              top: 40.0,
              left: 19.0,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 40.0,
              right: 21.0,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24.0),

        // 2. Product Title & Price Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ),
              const SizedBox(width: 24.0),
              Container(
                width: 80.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14.0),

        // 3. Farm & Rating Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 85.0,
                height: 14.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              const SizedBox(width: 16.0),
              Container(
                width: 120.0,
                height: 14.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18.0),

        // 4. Badges / Chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 75.0,
                height: 26.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                width: 90.0,
                height: 26.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                width: 65.0,
                height: 26.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20.0),

        // 5. Divider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 1.0,
            color: const Color(0xFFE2E6EA),
          ),
        ),

        const SizedBox(height: 20.0),

        // 6. Origin & Season rows
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 65.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  Container(
                    width: 110.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 65.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  Container(
                    width: 80.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24.0),

        // 7. Description block
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 110.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                height: 12.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                height: 12.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: screenWidth * 0.6,
                height: 12.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32.0),

        // 8. Bottom Action Bar (Quantity + Add to Cart)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 110.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32.0),
      ],
    );

    Widget detailContent = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedHeight) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: columnContent,
          );
        }
        return columnContent;
      },
    );

    if (w != null && w.isFinite || h != null && h.isFinite) {
      return SizedBox(
        width: (w != null && w.isFinite) ? w : null,
        height: (h != null && h.isFinite) ? h : null,
        child: detailContent,
      );
    }
    return detailContent;
  }

  // 5. Full Cart Screen Skeleton (Exact match for CartWidget)
  Widget _buildCart(BuildContext context, Color skeletonColor) {
    final double? w = widget.itemWidth ?? widget.width;
    final double? h = widget.itemHeight ?? widget.height;
    final double radius = widget.borderRadius > 0 ? widget.borderRadius : 12.0;

    final Widget columnContent = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: "My Cart" Title & item count subtitle
          Container(
            width: 96.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 6.0),
          Container(
            width: 55.0,
            height: 14.0,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            height: 1.0,
            color: const Color(0xFFE2E6EA),
          ),
          const SizedBox(height: 24.0),

          // Cart Items Container Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: const Color(0xFFE2E6EA)),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: 1.0,
                        color: const Color(0xFFF1F3F5),
                      ),
                    ),
                  _buildCartItemRow(context, skeletonColor),
                ],
                const SizedBox(height: 18.0),
                // "Keep shopping" link
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 110.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          // Order Summary Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: const Color(0xFFE2E6EA)),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110.0,
                  height: 15.0,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  height: 1.0,
                  color: const Color(0xFFE2E6EA),
                ),
                const SizedBox(height: 14.0),
                _summaryRow(skeletonColor, 68.0, 50.0),
                const SizedBox(height: 12.0),
                _summaryRow(skeletonColor, 88.0, 40.0),
                const SizedBox(height: 12.0),
                _summaryRow(skeletonColor, 76.0, 48.0),
                const SizedBox(height: 14.0),
                Container(
                  height: 1.0,
                  color: const Color(0xFFE2E6EA),
                ),
                const SizedBox(height: 14.0),
                _summaryRow(skeletonColor, 50.0, 70.0, height: 18.0),
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          // Checkout Button
          Container(
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(height: 40.0),
        ],
      ),
    );

    Widget cartContent = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedHeight) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: columnContent,
          );
        }
        return columnContent;
      },
    );

    if (w != null && w.isFinite || h != null && h.isFinite) {
      return SizedBox(
        width: (w != null && w.isFinite) ? w : null,
        height: (h != null && h.isFinite) ? h : null,
        child: cartContent,
      );
    }
    return cartContent;
  }

  // Single Cart Item Row
  Widget _buildCartItemRow(BuildContext context, Color skeletonColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image Thumbnail
          Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          const SizedBox(width: 12.0),
          // Product Name and Unit/Weight
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 115.0,
                  height: 13.0,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  width: 70.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          // Stepper + Price
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: const Color(0xFFE2E6EA)),
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                width: 48.0,
                height: 14.0,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Standalone Cart Item Card
  Widget _buildCartItem(BuildContext context, Color skeletonColor) {
    final double? w = widget.itemWidth ?? widget.width;
    final double? h = widget.itemHeight ?? widget.height;
    final double radius = widget.borderRadius > 0 ? widget.borderRadius : 12.0;

    return Container(
      width: w ?? double.infinity,
      height: h,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE2E6EA)),
      ),
      child: _buildCartItemRow(context, skeletonColor),
    );
  }

  Widget _summaryRow(Color skeletonColor, double labelW, double valW,
      {double height = 13.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: labelW,
          height: height,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        Container(
          width: valW,
          height: height,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ],
    );
  }

  // 6. Box Skeleton (Drop-in replacement for DataLoadWidget)
  Widget _buildBox(BuildContext context, Color skeletonColor) {
    final double w = widget.itemWidth ?? widget.width ?? double.infinity;
    final double h = widget.itemHeight ?? widget.height ?? 50.0;
    final double radius = widget.borderRadius;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
